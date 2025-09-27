# {{FEATURE}} — Flutter Implementation Plan

**Slug:** `{{SLUG}}`
**Updated:** {{NOW_ISO}}
**Repo:** `{{REPO_PATH}}`

> Phase 1 plan for **flutter-engineer**. This document is rendered from a template and will be **overwritten on rerun**. Implementation only proceeds after explicit approval (see §11). Tests are owned by the **flutter-tester** agent.

## 1) Scope & Intent
- **Goal:** <one-liner user outcome; e.g., paid onboarding flow with verified purchase → provisioned org → invite>
- **Non-goals:** <bullets to avoid scope creep>
- **Surfaces in scope:** routes/screens/widgets, BloCs, repositories/DTOs, error mapping, offline states.
- **Out of scope:** formal tests, CI/CD, backend edits.

## 2) Architecture Alignment (from arch/*)
- **Pattern:** Clean Architecture, MVVM with **BloC**; presentation ↔ Bloc ↔ Repository (data).
- **Navigation:** GoRouter with guards for auth/entitlements.
- **Contracts:** DTO heads mirror backend; canonical error codes mapped to UX.
- **Tenancy/Security hints:** client passes no secrets; `orgId` derived from token; App Check enforced server-side.

## 3) Work Breakdown (units of change)
- **Routing**
  - Files: `lib/features/{{SLUG}}/routes.dart`
  - Guards: auth, entitlement (plan/seat).
- **BloCs**
  - Files: `lib/features/{{SLUG}}/blocs/{{SLUG}}_bloc.dart`
  - Responsibilities: pure reducers; events→states; side-effects delegated to repos.
- **Views & Widgets**
  - Files: `lib/features/{{SLUG}}/views/*.dart`, `lib/features/{{SLUG}}/widgets/*.dart`
  - States: loading / empty / error / offline / success (explicit).
- **Repositories & DTOs**
  - Files: `lib/features/{{SLUG}}/repo/{{SLUG}}_repo.dart`, `{{SLUG}}_repo_impl.dart`, `dto/*.dart`
  - Responsibilities: map to backend contracts; handle errors; basic caching/offline per §9.

## 4) Routes & Screens (to implement)
{{ROUTES}}

| Route | Guard(s) | Screen | Notes |
|---|---|---|---|
| `<path>` | `auth`, `entitled(planTier)` | `<Screen>` | deep-link safe |

## 5) BloCs (events/states heads)
{{BLOCS}}

- **Events:** `Start`, `EditForm`, `Submit`, `Verify`, `Provision`, `Invite`, `Retry`, `GoOffline`, `GoOnline`
- **States:** `idle`, `collecting`, `verifyingPayment`, `provisioning`, `inviting`, `done`, `paymentFailed`, `verificationTimeout`, `provisionError`, `inviteError`, offline variants.

## 6) Repositories & DTOs
{{REPOS}}

**DTO heads**
{{DTO_HEADS}}

**Error mapping (canonical)**
| Code | UX Handling |
|---|---|
| `E.SEC.DENY` | access error UI; back to safe route |
| `E.SUB.NOT_ACTIVE` | route to paywall/billing screen |
| `E.IDEMP.DUP` | show success from cached outcome |
| `E.VAL.FIELD` | inline form errors |
| `E.EXT.PROVIDER` | transient toast + retry |
| `E.SYS.UNEXPECTED` | generic error; retry affordance |

## 7) UX States & Flows
- **Primary flow:** <bullet outline aligned to state machine>
- **Screens:** `<ScreenOne>`, `<ScreenTwo>`, `<Confirmation>`
- **Empty/Loading/Error/Offline/Success**: explicit widgets (reusable across feature).

## 8) Design System & A11y
- **Design system:** reuse `uikit` tokens/components; avoid new primitives unless justified.
{{DESIGN_SYSTEM_NOTES}}

- **Accessibility:** semantics labels, focus order, large text, RTL; tap targets ≥ 44px; contrast ≥ 4.5:1.
{{A11Y_NOTES}}

## 9) Offline & Resilience
{{OFFLINE_NOTES}}

- **Behavior:** allow form while offline; queue submit; resume on reconnect.
- **Idempotency client-side:** persist `{requestId, payload}` until server confirms; reconcile duplicate success.

## 10) Directory Layout (target)
```text
lib/features/{{SLUG}}/
  routes.dart
  blocs/{{SLUG}}_bloc.dart
  views/{{SLUG}}_page.dart
  views/{{SLUG}}_form.dart
  widgets/{loading_state,error_state,empty_state}.dart
  repo/{{SLUG}}_repo.dart
  repo/{{SLUG}}_repo_impl.dart
  dto/{request_dto,response_dto}.dart
  localization/l10n_{{SLUG}}.arb (if intl used)
````

## 11) Approval Gate (required before code)

* **Reviewer(s):** <name(s)>
* **Checklist:**

  * [ ] Routes/guards and screens approved
  * [ ] BloC events/states agreed (pure reducers; side-effects in repos)
  * [ ] Repository interfaces and DTO heads approved
  * [ ] Error mapping ↔ codes approved
  * [ ] A11y & design-system usage approved
  * [ ] Offline/resilience behavior accepted
* **To approve:** create non-empty file `.agents/{{SLUG}}/flutter/APPROVED` **or** invoke `flutter-engineer: {{SLUG}} --apply`.

## 12) Apply Plan (summary of changes on approval)

* Create feature folders/files per §10.
* Implement routes/guards, BloC, views/widgets, repositories/DTOs.
* Wire error mapping & offline behavior.
* Append concise diff to `.agents/{{SLUG}}/logs/flutter-changes.md`.

## 13) Risks & Mitigations

| Risk                         | Impact            | Likelihood | Mitigation                                             |
| ---------------------------- | ----------------- | ---------: | ------------------------------------------------------ |
| Navigation guard regressions | Broken deep-links |        Med | Guard unit in tester; manual smoke during apply        |
| State explosion              | Hard-to-test UI   |        Med | Consolidate via sealed states; limit one BloC per flow |
| Offline conflicts            | Bad UX on resume  |        Low | Display queued state; reconcile via server outcome     |

## 14) Open Questions

1. <question> — **Owner:** <name> — **Due:** <date>
2. <question> — **Owner:** <name> — **Due:** <date>
