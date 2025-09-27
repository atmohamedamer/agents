# {{FEATURE}} — Backend Runbook

**Slug:** `{{SLUG}}`
**Updated:** {{NOW_ISO}}
**Repo:** `{{REPO_PATH}}`

> Operational steps for **backend-engineer**. This file is template-rendered and **overwritten on rerun**. Tests are owned by the **backend-tester** agent.

## 1) Preconditions (must be true)
- `plan.md` approved (see plan §10).
- Repo resolved from `.agents/config.json` and reachable.
- Node LTS installed; Firebase CLI available locally.
- Auth to project/emulators available (no production deploy in this runbook).

**Branch naming**
```bash
cd {{REPO_PATH}}
git checkout -b feat/{{SLUG}}
````

## 2) Local setup

```bash
# install
npm ci

# sanity: lint & typecheck
npm run lint
npm run typecheck || npm run build --workspaces=false

# start emulators (Firestore, Auth, Functions)
npm run emu:start   # or: firebase emulators:start --only firestore,auth,functions
```

**Env & config (heads)**

* Runtime config via `functions/src/common/config.ts` (no secrets in client).
* Service account usage limited to local emulators where required.

## 3) Files to create/modify (exact paths)

```text
functions/src/features/{{SLUG}}/
  interface/
    http_{{SLUG}}.ts            # HTTP handler(s)
    callable_{{SLUG}}.ts        # Callable(s) if applicable
    webhook_provider.ts         # Provider webhook adapter (server-only)
  service/
    verify_payment.uc.ts        # example use-case (rename per feature)
    provision_org.uc.ts
  domain/
    organization.entity.ts
    subscription.entity.ts
    errors.ts                   # E.SEC.DENY, E.SUB.NOT_ACTIVE, E.IDEMP.DUP, ...
  data/
    org.repo.ts
    sub.repo.ts
    provider.client.ts          # e.g., Stripe/IAP adapter behind interface

firestore.rules.d/{{SLUG}}.rules
firestore.indexes.d/{{SLUG}}.json
emulator/seeds/{{SLUG}}.json            # optional seeds/fixtures
```

> Keep handlers **thin**; orchestration in `service/*.uc.ts`; domain **pure**; data adapters tenancy-aware.

## 4) Entry points (implement)

{{ENTRYPOINTS}}

**DTO heads**

* **Request:** `{ orgId: string, requestId: string, payload: {...} }`
* **Response:** `{ ok: boolean, code?: string, data?: {...}, traceId: string }`

**Edge guards**

* Require **Auth** + **App Check**.
* Assert `payload.orgId === auth.token.orgId`.
* Validate DTO (reject unknowns / size caps).
* Derive **idempotencyKey** from `requestId` or provider ref.

## 5) Security & tenancy

* Rules fragment: `{{RULES_PATH}}/{{SLUG}}.rules` (import into root rules).

  * Deny-by-default. Read if `resource.data.orgId == token.orgId`. Writes **server-only**.
* Indexes fragment: `{{INDEXES_PATH}}/{{SLUG}}.json` — composites minimal but sufficient.
* Repos: always filter by `orgId`; no client writes to privileged paths.

## 6) Idempotency & error mapping

| Path          | Key           | Store               | Duplicate behavior  |
| ------------- | ------------- | ------------------- | ------------------- |
| callable/http | `requestId`   | outcomes collection | return last-success |
| webhook       | `providerRef` | outcomes collection | return 200 + no-op  |

| Code               | Meaning                | Edge handling         | UI hint          |
| ------------------ | ---------------------- | --------------------- | ---------------- |
| `E.SEC.DENY`       | forbidden/cross-tenant | 403/permission-denied | access error     |
| `E.SUB.NOT_ACTIVE` | inactive sub           | 400                   | route to billing |
| `E.IDEMP.DUP`      | duplicate              | 200                   | show success     |
| `E.VAL.FIELD`      | invalid dto/field      | 400                   | inline errors    |
| `E.EXT.PROVIDER`   | provider fail/timeout  | 502 + retry/backoff   | transient        |
| `E.SYS.UNEXPECTED` | unhandled              | 500                   | generic error    |

## 7) Observability (wire once, use everywhere)

{{OBSERVABILITY_SUMMARY}}

**Server logging fields (minimum):** `traceId, orgId, feature:"{{SLUG}}", action, status, code, latencyMs, idempotencyKey`.

## 8) Implementation steps (Apply mode)

1. **Scaffold** directories/files per §3.
2. **Implement** handlers → services → domain → data (in that order).
3. **Add Rules/Indexes** fragments.
4. **Wire common libs** (`auth.ts`, `idempotency.ts`, `logging.ts`) if missing.
