# {{FEATURE}} — Plan

**Slug:** `{{SLUG}}`
**Updated:** {{NOW_ISO}}

## 1) Summary
<3–6 sentences: intent, user value, why-now. Keep crisp.>
- **In scope:** <bullets>
- **Out of scope:** <bullets>
- **Dependencies:** <e.g., configs, feature flags, service accounts>

**Design refs / UI links:** {{UI_LINKS}}

## 2) Repo Map
| key | path | type | description |
|---|---|---|---|
{{REPO_MAP_TABLE}}

## 3) Constraints & Assumptions
- **Tenancy:** multi-tenant Firestore — every doc carries `orgId`; deny cross-tenant reads/writes via Rules and app-layer checks.
- **Architecture:** Clean Architecture (interface → service → domain → data); server-only privileged writes.
- **Client:** Flutter Clean Architecture with MVVM using **BloC**; GoRouter for navigation; reuse `uikit` components/tokens.
- **AI/Automation:** Genkit flows only behind secure Cloud Functions; schemas validate all inputs/outputs.
- **Security:** Firebase Auth + **App Check** enforced; least-privilege Rules; no PII in logs.
- **Entitlements:** quotas/plan gates enforced in server logic; custom claims mirror essentials.
- **Assumptions:** Auth=Firebase; feature flags available; repo keys/paths remain stable.

## 4) Non-Functional Requirements (NFRs)
| Category | Target | Notes |
|---|---|---|
| … | … | … |

## 5) Interfaces (inventory)
- **Server entrypoints:** <HTTP/Callable names + purpose; triggers if any>
- **Events:** <Pub/Sub topics published/consumed + payload heads>
- **Client surfaces:** <screens/routes/components>
- **Feature flags:** `<flag_name>` (<default>, owner)

## 6) Data & Contracts (guidance)
- **Collections:** <name, scope (tenant/global), purpose, sample keys>
- **Requests** (must include): `orgId`, `requestId` (for idempotency), payload DTO
- **Responses** (must include): `{ ok, code?, data?, traceId? }`
- **Indexes:** <composites anticipated>
- **Error taxonomy:** `E.SEC.DENY`, `E.SUB.NOT_ACTIVE`, `E.IDEMP.DUP`, `E.VAL.FIELD`, `E.EXT.PROVIDER`, `E.SYS.UNEXPECTED`

## 7) UX Notes
- **Primary flows:** <bullets>
- **States:** loading / empty / error / offline / success
- **A11y:** labels, focus order, contrast, RTL/large text
- **Design system:** reuse `uikit`; justify any new primitives
- **UX/UI callouts:** missing or invalid flows

## 8) Risks & Mitigations
| Risk | Impact | Likelihood | Mitigation |
|---|---|---:|---|
| … | … | … | … |

## 9) Open Questions
1) <question> — **Owner:** <name> — **Due:** <date>
2) <question> — **Owner:** <name> — **Due:** <date>

## 10) Execution Checklist (entry/exit)

- [ ] **Plan** (this doc)
  **Exit:** approved by product/design/eng leads

- [ ] **Research** *(researcher)*
  **Entry:** brief + plan
  **Exit:** `research/current-state.md`, `research/options.md`, `research/recommendation.md`

- [ ] **Architect** *(architect)*
  **Entry:** research recommendation
  **Exit:** `arch/architecture.md`, `arch/structure.tree.md`, `arch/security-and-tenancy.md`, `arch/telemetry-and-testing.md`, `arch/state-and-flows.md`

- [ ] **Backend Impl** *(backend-engineer)*
  **Entry:** architecture (and any contracts)
  **Exit:** code in repo; `backend/plan.md`, `backend/runbook.md`; Rules & Indexes fragments; unit+emulator tests green

- [ ] **Backend Review** *(backend-reviewer)*
  **Entry:** staged backend changes
  **Exit:** `reviews/backend` notes; required deltas applied/queued

- [ ] **Backend Tester** *(backend-tester)*
  **Entry:** reviewed backend changes
  **Exit:** `qa/backend/test-plan.md`, `qa/backend/results.md`; defects triaged

- [ ] **Flutter Impl** *(flutter-engineer)*
  **Entry:** architecture/fixtures
  **Exit:** code in repo; `flutter/plan.md`, `flutter/runbook.md`; bloc/widget/golden tests added

- [ ] **Flutter Review** *(flutter-reviewer)*
  **Entry:** staged flutter changes
  **Exit:** `reviews/flutter` notes; required deltas applied/queued

- [ ] **Flutter Tester** *(flutter-tester)*
  **Entry:** reviewed frontend changes
  **Exit:** `qa/flutter/test-plan.md`, `qa/flutter/results.md`; defects triaged

## 11) Acceptance Criteria
- Backend compiles; emulator/unit tests pass; Rules least-privilege; required indexes present; App Check enforced.
- Flutter compiles; BloC/widget/golden/integration tests pass; A11y/RTL verified.
- Quotas/plan gates enforced; structured logs/metrics present; no PII logs.
- No open critical risks; all checklist exits satisfied.
