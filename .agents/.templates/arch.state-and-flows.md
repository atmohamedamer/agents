# {{FEATURE}} — State & Flows

**Slug:** `{{SLUG}}`<br/>
**Updated:** {{NOW_ISO}}

## 1) Core States (canonical)
- `idle` → `collecting` → `verifyingPayment` → `provisioning` → `inviting` → `done`
- **Error sub-states:** `paymentFailed`, `verificationTimeout`, `provisionError`, `inviteError`
- **Offline variants:** `offlineCollecting`, `queuedProvision`, `queuedInvite`

> Each state renders UI and exposes deterministic retry/continue actions.

## 2) State Machine (heads)
```mermaid
stateDiagram-v2
  [*] --> idle
  idle --> collecting: start()
  collecting --> verifyingPayment: submitPayment(formValid)
  verifyingPayment --> provisioning: verified(receiptOk)
  verifyingPayment --> paymentFailed: verified(fail) / reason
  verifyingPayment --> verificationTimeout: timeout
  paymentFailed --> collecting: retry
  verificationTimeout --> verifyingPayment: retry
  provisioning --> inviting: provisioned
  provisioning --> provisionError: fail
  inviting --> done: allInvitesSent
  inviting --> inviteError: fail
  provisionError --> provisioning: retry
  inviteError --> inviting: retry
  collecting --> offlineCollecting: offline
  offlineCollecting --> verifyingPayment: online && submit
````

## 3) BloC/Event Model (Flutter)

* **Events:** `Start`, `EditForm`, `SubmitPayment`, `Verify`, `Provision`, `Invite`, `Retry`, `GoOffline`, `GoOnline`
* **States:** mirror Core States; reducers **pure**, side-effects in repositories/services.
* **Guards:** form validity, network availability, entitlement checks.
* **Side-effects mapping:**

  * `SubmitPayment` → call `verifyPayment()` (edge); emit `verifyingPayment`
  * `Verify.success` → `provision()`; emit `provisioning`
  * `Provision.success` → `sendInvites()`; emit `inviting`

## 4) Backend Orchestration (verify → provision)

```mermaid
sequenceDiagram
  participant UI as Client (Flutter)
  participant IF as Interface (HTTP/Callable)
  participant SV as Service (Use-case)
  participant FS as Firestore
  participant PV as Provider (Stripe/IAP)

  UI->>IF: submitPayment({orgId, requestId, payload})
  IF->>IF: Auth+AppCheck+DTO validate; derive idempotencyKey
  IF->>PV: verifyReceipt()
  PV-->>IF: result(ok|fail, providerRef)
  IF->>SV: verifyPayment({orgId, providerRef, idempotencyKey})
  SV->>FS: upsert Subscription/Payment (idempotent by providerRef)
  SV-->>IF: verified
  IF->>SV: provisionOrg({orgId, requestId})
  SV->>FS: create/update org resources + entitlements (txn/batch)
  SV-->>IF: provisioned
  IF-->>UI: { ok, data, traceId }
```

**Idempotency**

* Client: `requestId` per submit.
* Server: de-dup by `providerRef` (webhooks) or `requestId` (callables). On duplicate, return last-success.

## 5) Data Touch Points (heads)

* **Reads:** `Subscriptions/{orgId}`, `Organizations/{orgId}`, plan/seat configs.
* **Writes:** `Subscriptions/*` (server-only), `Organizations/*` (server-only), `Invites/*`.
* **Indexes (likely):** `Subscriptions: [orgId, status]`, `Invites: [orgId, email]`.

## 6) Error & Retry Flow

* **Payment failure (`E.EXT.PROVIDER`)** → `paymentFailed` with retry/backoff hint.
* **Verification timeout** → exponential backoff; user-resumable.
* **Provision error (`E.SYS.UNEXPECTED`)** → safe to retry (idempotent).
* **Invite error** → partial-failure handling; per-invite retries.

## 7) Offline Behavior

* **Collecting:** allow form entry; queue submit until `online`.
* **After submit:** if offline before verify, persist payload + `requestId`; resume on reconnect.
* **UI:** explicit offline banner; disabled transitions that require server.

## 8) Guards & Invariants

* `orgId` from token must equal payload `orgId`.
* Must **not** create org resources before verified payment.
* Entitlements (plan tier, seat caps) enforced in service; client is advisory only.

## 9) Telemetry Hooks (per transition)

* `action=submitPayment|verify|provision|invite`, include `traceId`, `orgId`, `status`, `latencyMs`, `code` (taxonomy).
* Metrics increment on success/fail; traces span each backend call.

## 10) Open Issues

* <state/transition ambiguity> — **Owner:** <name> — **Due:** <date>
* <edge-case to simulate> — **Owner:** <name> — **Due:** <date>

## 11) References (top)

{{TOP_REFS}}
