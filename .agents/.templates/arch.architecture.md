# {{FEATURE}} — Architecture

**Slug:** `{{SLUG}}`<br/>
**Updated:** {{NOW_ISO}}

## 1) Overview
- **Selected approach:** {{SELECTED_OPTION}}
- **Intent:** <one-liner of user value/why-now>
- **Context:** Clean Architecture; Flutter MVVM with **BloC**; Firebase Functions + Firestore; App Check enforced; multi-tenant (`orgId`).
- **Design refs / UI links:** {{UI_LINKS}}

## 2) System Diagram (heads)
```mermaid
flowchart TB
  subgraph Client [Flutter App]
    UI[Views/Widgets]
    BLOC[BloCs]
    REPO[Repositories]
  end
  subgraph Edge [Cloud Functions]
    HTTP[HTTP/Callable]
    JOBS[Schedulers/Webhooks]
  end
  FS[(Firestore)]
  EXT[(Providers: Stripe/IAP/etc.)]
  GEN[Genkit Flow]

  UI --> BLOC --> REPO --> HTTP
  HTTP <--> FS
  HTTP <--> GEN
  HTTP <--> EXT
  JOBS --> HTTP
````

## 3) Components & Responsibilities

* **Client (Flutter)**
  * Views (GoRouter routes), **BloC** per flow, Repositories (DTO adapters), offline states.
* **Edge (Functions)**
  * HTTP/Callable entrypoints, validation/auth/App Check, idempotency, error mapping.
* **Service (Use-cases)**
  * Orchestrate domain logic, retries/backoff, emit events.
* **Domain**
  * Entities/Value Objects, invariants, pure rules.
* **Data**
  * Firestore repos (tenancy-aware), external provider clients behind interfaces.

## 4) Contracts (heads)

* **Request DTO:** `{ orgId: string, requestId: string, payload: {...} }`
* **Response DTO:** `{ ok: boolean, code?: string, data?: {...}, traceId: string }`
* **Error codes:** `E.SEC.DENY`, `E.SUB.NOT_ACTIVE`, `E.IDEMP.DUP`, `E.VAL.FIELD`, `E.EXT.PROVIDER`, `E.SYS.UNEXPECTED`

## 5) Entry Points (today → target)

* **HTTP/Callable:** <name → purpose → auth/claims → App Check → input DTO>
* **Webhooks/Schedulers:** <name → trigger → idempotency key → retries>
* **Events (Pub/Sub, if any):** <topic → payload head → consumer>

## 6) Data Model & Indexes (must-have)

* **Collections (tenant-owned):** <name> — owner: `orgId` — fields: <list>
* **Read patterns:** <query examples per flow>
* **Composite indexes:**

  * `<collection>: [fieldA ASC, fieldB DESC]` — rationale
  * `<collection>: [orgId, status]` — rationale

> Keep minimal but sufficient; add-on indexes in runbooks.

## 7) Tenancy & Security (summary)

* **Ownership:** every doc carries `orgId`; all reads/writes filter on `orgId`.
* **Rules:** least-privilege fragments; server-only privileged mutations.
* **App Check:** required on client-originated calls.
* **Claims:** mirror entitlements (plan tier, seat caps); refresh after mutations.

## 8) Idempotency & Consistency

* **Key:** `requestId` (client) or `providerRef` (webhooks) — store outcome; return last-success on duplicate.
* **Transactions:** batch where atomic; otherwise apply outbox/event with de-dup.

## 9) Observability

* **Logs:** structured; `traceId`, `orgId`, `feature`, `code`, `latencyMs`.
* **Metrics:** success/error rates, p95/p99 latency per entrypoint, retry/idempotency collisions.
* **Traces:** wrap handlers; annotate external calls.

## 10) Verify → Provision (golden path)

1. Client collects config → requests quote.
2. Provider payment → **server-side verify** (webhook/receipt).
3. **Provision** org resources & entitlements (single use-case).
4. Emit events/telemetry; return normalized response.

## 11) Code Scan Highlights (context)

{{CODE_FINDINGS}}

## 12) Key Gaps Influencing Design

{{KEY_GAPS}}

## 13) Open Issues

* <issue> — **Owner:** <name> — **Due:** <date>
* <issue> — **Owner:** <name> — **Due:** <date>

## 14) References (top)

{{TOP_REFS}}
