# {{FEATURE}} — Backend Implementation Plan

**Slug:** `{{SLUG}}`
**Updated:** {{NOW_ISO}}
**Repo:** `{{REPO_PATH}}`

> Phase 1 plan for **backend-engineer**. This document is rendered from a template and will be **overwritten on rerun**. Implementation only proceeds after explicit approval.

## 1) Scope & Intent
- **Goal:** <one-liner of the server-side outcome; e.g., verify payment → provision org → emit events>
- **Non-goals:** <bullets to avoid scope creep>
- **Interfaces in scope:** {{ENTRYPOINTS}}
- **Out of scope:** tests (handled by backend-tester), CI/CD, deployments.

## 2) Architecture Alignment (from arch/*)
- **Layering:** Interface → Service (use-cases) → Domain (pure) → Data (Firestore/providers).
- **Tenancy & Security:** `orgId` ownership, least-privilege Rules, App Check enforced.
- **Observability (heads):** {{OBSERVABILITY_SUMMARY}}

## 3) Work Breakdown (units of change)
- **Interface (HTTP/Callable/Webhook)**
  - Files: `functions/src/features/{{SLUG}}/interface/*.ts`
  - Responsibilities: auth + App Check, DTO validate, idempotency key, error mapping.
- **Use-cases / Services**
  - Files: `.../service/*.uc.ts`
  - Responsibilities: orchestration, retries/backoff, emit events, enforce entitlements.
- **Domain (entities/value objects)**
  - Files: `.../domain/*.entity.ts`, `.../domain/errors.ts`
  - Responsibilities: invariants, state transitions, error taxonomy constants.
- **Data (Firestore + providers)**
  - Files: `.../data/*.(repo|client).ts`
  - Responsibilities: tenancy-aware queries, provider adapters behind interfaces.

## 4) Entry Points (to implement)
| Name | Type | Auth | App Check | Request DTO | Response DTO | Error Codes |
|---|---|---|---|---|---|---|
| `<name>` | HTTP/Callable | required | required | `{ orgId, requestId, payload }` | `{ ok, code?, data?, traceId }` | `E.*` |
| `<webhook>` | HTTP | server-only | n/a | provider-specific | `{ ok }` | `E.EXT.PROVIDER`, `E.IDEMP.DUP` |

## 5) Data Model (heads)
- **Collections (tenant-owned):**
  - `<Collection>` — owner: `orgId`; fields: `<f1,f2,...>`; read patterns: `<queries>`
- **DTOs:** request/response heads mirror `api/json-schemas/**` if present (validate at edge).
- **Events (if any):** `<topic>` — payload heads `{ orgId, ... }` with idempotency key.

## 6) Security, Rules & Indexes
- **Rules fragment:** `{{RULES_PATH}}/{{SLUG}}.rules`  
  - Deny-by-default; allow reads if `resource.data.orgId == token.orgId`; all writes server-only.
- **Index fragment(s):** `{{INDEXES_PATH}}/{{SLUG}}.json`  
  - Minimal composites required for the read patterns listed above.
- **Edge guards:** Auth + App Check + `orgId` equality asserted at interface.

## 7) Idempotency & Error Taxonomy
- **Idempotency:** `requestId` (client) and/or `providerRef` (webhook) → store outcome, return last-success on duplicate.
- **Canonical error codes:** `E.SEC.DENY`, `E.SUB.NOT_ACTIVE`, `E.IDEMP.DUP`, `E.VAL.FIELD`, `E.EXT.PROVIDER`, `E.SYS.UNEXPECTED`.

## 8) Directory Layout (target)
```text
functions/src/features/{{SLUG}}/
  interface/        # handlers: http_*.ts, callable_*.ts, webhook_*.ts
  service/          # use-cases: *.uc.ts (orchestrations)
  domain/           # *.entity.ts, errors.ts (pure)
  data/             # *.repo.ts (Firestore), *provider*.client.ts
  __tests__/        # (stubs only; tester agent writes real tests)
firestore.rules.d/{{SLUG}}.rules
firestore.indexes.d/{{SLUG}}.json
emulator/seeds/{{SLUG}}.json (optional)
````

## 9) Risks & Mitigations

| Risk               | Impact                 | Likelihood | Mitigation                                                          |
| ------------------ | ---------------------- | ---------: | ------------------------------------------------------------------- |
| Missing composites | Run-time query failure |        Med | Ship minimal `*.json` composites with plan                          |
| Webhook replay     | Double writes          |        Med | Idempotent by `providerRef`; store+return last-success              |
| Cross-tenant leak  | Sev                    |        Low | Rules + edge `orgId` assertions; emulator deny tests (tester agent) |
| Cold starts        | Latency                |        Low | Keep handlers thin; lazy provider clients                           |

## 10) Approval Gate (required before code)

* **Reviewer(s):** <name(s)>
* **Checklist:**

  * [ ] Entry points, DTO heads, and error codes approved
  * [ ] Rules fragment reviewed (least-privilege)
  * [ ] Index fragments minimal & sufficient
  * [ ] Idempotency strategy accepted
  * [ ] Directory layout agreed
* **To approve:** create non-empty file `.agents/{{SLUG}}/backend/APPROVED` **or** invoke `backend-engineer: {{SLUG}} --apply`.

## 11) Apply Plan (summary of changes on approval)

* Create feature folders; add handlers/use-cases/domain/data.
* Add `firestore.rules.d/{{SLUG}}.rules` and `firestore.indexes.d/{{SLUG}}.json`.
* Wire common libs: `auth.ts`, `idempotency.ts`, `logging.ts` (extend if exist).
* Seed optional fixture `emulator/seeds/{{SLUG}}.json`.
* Append concise diff to `.agents/{{SLUG}}/logs/backend-changes.md`.

## 12) Open Questions

1. <question> — **Owner:** <name> — **Due:** <date>
2. <question> — **Owner:** <name> — **Due:** <date>
