# {{FEATURE}} — Telemetry & Testing

**Slug:** `{{SLUG}}`<br/>
**Updated:** {{NOW_ISO}}

## 1) Observability Plan
- **Goals:** rapid defect isolation, tenant-safe tracing, budget enforcement (p95/p99), and SLA visibility.
- **Correlation fields (every log/metric/trace):** `traceId`, `orgId`, `feature: "{{SLUG}}"`, `action`, `code`, `status`.
- **PII policy:** never log PII or provider secrets; redact tokens/receipts.

### 1.1 Logs (structured)
- **Server (Functions):** log on entry/exit + error paths. Fields: `latencyMs`, `attempt`, `idempotencyKey`, `externalProvider`.
- **Client (Flutter):** info-level user flow breadcrumbs; errors mapped to taxonomy codes; no sensitive payloads.

### 1.2 Metrics
| Metric | Type | Dimensions | Target / Alert |
|---|---|---|---|
| requests_total | counter | `action, status, code` | n/a |
| latency_ms | histogram | `action` | p95 < 300ms, p99 < 800ms |
| retries_total | counter | `action` | alert if spike > baseline + 3σ |
| idempotency_collisions | counter | `action` | alert if > 0.5% of requests |
| webhook_verify_fail | counter | `provider` | alert on any non-test env |

### 1.3 Traces
- **Span roots:** each HTTP/Callable handler.
- **Annotations:** external calls (Stripe/IAP), Firestore reads/writes, retries/backoff attempts.
- **Links:** propagate `traceId` to client where applicable (debug-only surfaces).

## 2) Error Taxonomy (canonical)
| Code | Layer | Meaning | Client Handling |
|---|---|---|---|
| `E.SEC.DENY` | rules/service | Forbidden or cross-tenant | show “no access”; log warn |
| `E.SUB.NOT_ACTIVE` | service | Subscription inactive | route to billing/paywall |
| `E.IDEMP.DUP` | interface | Duplicate request/replay | show success from cache |
| `E.VAL.FIELD` | interface | Invalid DTO/field | inline form errors |
| `E.EXT.PROVIDER` | service | Provider error/timeout | retry/backoff; surface toast |
| `E.SYS.UNEXPECTED` | service | Unhandled failure | generic error; capture trace |

> Codes must be the **only** error contract exposed to UI; messages are localized client-side.

## 3) Test Strategy (end-to-end)
- **Principles:** deterministic fixtures, hermetic tests (emulators), fail-fast signals, minimal mocks beyond boundaries.

### 3.1 Backend
- **Unit (domain/service):** invariants, orchestration, idempotency logic.
- **Emulator integration:** Auth + Firestore + Functions. Positive/negative Rules tests (cross-tenant, missing App Check).
- **Contract tests:** request/response JSON validated by `api/json-schemas/**`; fixtures round-trip.
- **Webhook tests:** signature verification, replay protection, duplicate processing returns last-success.

### 3.2 Flutter
- **BloC tests:** events → states; reducers pure; side-effects mocked at repo boundary.
- **Widget tests:** screens render all states (loading/empty/error/offline/success).
- **Golden tests:** primary states; dark/light; large text; RTL.
- **Integration tests:** happy path (verify → provision → invite); offline/restore; back button/navigation.

### 3.3 Data & Fixtures
- **Seeds:** `.agents/{{SLUG}}/api/fixtures/**` mirrored into emulator seed.
- **Factories:** deterministic builders for entities/DTOs; no randomness without seeding.

## 4) Test Matrix (heads)
| Layer | Case | Tooling | Pass Criteria |
|---|---|---|---|
| Rules | cross-tenant read denied | Firestore emulator | deny |
| Service | duplicate request idempotent | unit | same result; no extra writes |
| Handler | missing App Check rejected | Functions emulator | 401/permission-denied |
| Webhook | replay detected | Functions emulator | 200 + no-op write |
| BloC | payment fail → error state | Flutter test | error UI + retry visible |
| Widget | offline state | Flutter test | offline banner; queue shown |
| Golden | success state | golden | matches baseline |
| E2E | verify→provision | integration | all steps pass; metrics emit |

## 5) Alerts & SLOs
- **SLOs:** availability ≥ 99.9%; p95 < 300ms per handler.
- **Page on:** `latency_ms.p95` breach 5m, `webhook_verify_fail > 0`, `idempotency_collisions` spike, 5xx/`E.SYS.UNEXPECTED` rate > threshold.

## 6) Tooling & Config
- **Emulators:** Firestore, Auth, Functions (scripted startup + seeds).
- **Test runners:** Vitest (backend), Flutter test/espresso-style integration.
- **CI hooks:** optional (outside this agent); local scripts included in runbooks.
