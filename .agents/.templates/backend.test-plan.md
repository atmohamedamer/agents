# {{FEATURE}} — Backend Test Plan

**Slug:** `{{SLUG}}`
**Updated:** {{NOW_ISO}}
**Rules:** `{{RULES_PATH}}/{{SLUG}}.rules`
**Indexes:** `{{INDEXES_PATH}}/{{SLUG}}.json`

> Plan for **backend-tester**. Template-rendered and **overwritten on rerun**. Tests run on local **Firebase Emulators** only. No external network.

## 1) Scope & Objectives
- **Goal:** validate backend behavior against architecture and contracts using unit + emulator integration tests.
- **In scope:** handlers (HTTP/Callable/Webhook), services, repos (Firestore), Rules, composite indexes, idempotency, canonical error codes, observability heads.
- **Out of scope:** performance/stress, deployment/CI, end-to-end mobile UI.

## 2) Preconditions & Assumptions
- Node LTS, Firebase CLI, emulators for **Auth/Firestore/Functions** available.
- Backend repo path resolved from `.agents/config.json`.
- DTO heads & fixtures stable (if present under `.agents/{{SLUG}}/api/**`).
- No production credentials; all provider calls are faked.

## 3) Entry Points Under Test
{{ENTRYPOINTS}}

| Name | Type | Auth | App Check | Mutates | Idempotency Key | Notes |
|---|---|---|---|---|---|---|
| `<http_foo>` | HTTP | yes | yes | yes | `requestId` | happy + dup |
| `<callable_bar>` | Callable | yes | yes | maybe | `requestId` | … |
| `<webhook_provider>` | HTTP | server | n/a | yes | `providerRef` | replay |

## 4) Canonical Error Taxonomy
{{ERROR_TAXONOMY}}

| Code | Meaning | Test Surfaces |
|---|---|---|
| `E.SEC.DENY` | forbidden / cross-tenant | Rules + handler |
| `E.SUB.NOT_ACTIVE` | inactive subscription | handler/service |
| `E.IDEMP.DUP` | duplicate request | handler/webhook |
| `E.VAL.FIELD` | invalid DTO | handler edge |
| `E.EXT.PROVIDER` | provider fail/timeout | webhook/service |
| `E.SYS.UNEXPECTED` | unhandled | handler fallback |

## 5) Fixtures & Seeds
- **Requests:** `functions/src/features/{{SLUG}}/__tests__/fixtures/requests/*.json`
- **Responses:** `functions/src/features/{{SLUG}}/__tests__/fixtures/responses/*.json`
- **Seeds:** `functions/src/features/{{SLUG}}/__tests__/fixtures/seeds/*.json`
- **Tenants:** at least **two** orgs (`orgA`, `orgB`) to verify cross-tenant denies.

## 6) Environment & Commands
```bash
npm ci
npm run emu:start --silent &  # Firestore, Auth, Functions
EMUPID=$!

npm run typecheck || npx tsc --noEmit
npm test -- --run

kill $EMUPID || true
```

## 7) Test Matrix (Happy / Edge / Negative)

> Use AAA style; assert codes/bodies, side-effects, and logs.

### 7.1 Handlers (HTTP/Callable)

| Case                   | Given                          | When                    | Then                                                         |
| ---------------------- | ------------------------------ | ----------------------- | ------------------------------------------------------------ |
| Happy path             | auth+appcheck valid, valid DTO | call `<http_foo>`       | `200 {ok:true}`, side-effects present, structured log fields |
| Missing App Check      | auth valid, **no** App Check   | call `<http_foo>`       | `401/permission-denied`                                      |
| Cross-tenant           | token.orgId≠payload.orgId      | call `<http_foo>`       | `403` + `E.SEC.DENY`                                         |
| Invalid DTO            | missing required field         | call `<http_foo>`       | `400` + `E.VAL.FIELD`                                        |
| Duplicate (idempotent) | prior success stored           | resend same `requestId` | `200` + `E.IDEMP.DUP` or same outcome; **no new writes**     |

## 8) Tenancy & Rules

* **Rules allow:** same-tenant reads where specified; **deny** cross-tenant R/W.
* **Server-only:** privileged writes not allowed from client context.

| Case              | Path                  | Actor     | Expectation              |
| ----------------- | --------------------- | --------- | ------------------------ |
| Same-tenant read  | `/Collection/{id}`    | orgA user | allow if `orgId == orgA` |
| Cross-tenant read | `/Collection/{id}`    | orgB user | **deny**                 |
| Any write         | privileged collection | client    | **deny**                 |

> Validate via Firestore emulator; include negative tests.

## 9) Index Coverage

* Ensure each documented query has a matching composite index in `{{INDEXES_PATH}}/{{SLUG}}.json`.
* Strategy:

  * **Static check:** parse queries and compare fields → composites.
  * **Runtime trap:** run queries w/o indexes (expect emulator error), then assert presence/usage after adding fragment.

| Query                           | Expected Composite | Verified |
| ------------------------------- | ------------------ | -------- |
| `<Coll>[orgId asc, status asc]` | yes                | <y/n>    |

## 10) Observability Heads

* Assert presence of structured log fields at handler boundary:
  `traceId, orgId, feature:"{{SLUG}}", action, code, latencyMs, idempotencyKey`.

| Case                        | Expect                                |
| --------------------------- | ------------------------------------- |
| Any handler success/failure | log line contains all fields (no PII) |

## 11) Data Integrity & Side-Effects

* **At-least-once** events deduped by key.
* **Idempotency store** written once; duplicates return cached outcome.
* **No** cross-tenant writes/reads in side-effects.

## 12) Exit Criteria

* All matrix cases implemented and **passing** on emulators.
* Rules tests prove cross-tenant denial and same-tenant allows where intended.
* Index coverage verified; no emulator “missing index” errors.
* Canonical error codes only; no raw provider errors surfaced.
* Observability heads present; logs contain required fields.
* Results documented in `qa/backend/results.md` (pass/fail counts, defects).

## 13) Risks & Mitigations

| Risk                 | Impact              | Likelihood | Mitigation                                   |
| -------------------- | ------------------- | ---------: | -------------------------------------------- |
| Emulator flakiness   | false negatives     |        Low | retry isolated cases; seed deterministically |
| Time-based logic     | flaky assertions    |        Low | fixed times; inject clock                    |
| Provider mocks drift | invalid assumptions |        Med | centralize fakes; align with fixtures        |


## 14) Defects & Ownership (created during execution)

| ID   | Sev | Title | Owner | Status |
| ---- | --: | ----- | ----- | ------ |
| DEF- |     |       |       |        |

## 15) Approval Gate

* **Approve when:** all exit criteria met; **Blocker/High** defects closed or waived with sign-off.
* **Approver(s):** <name(s)>
