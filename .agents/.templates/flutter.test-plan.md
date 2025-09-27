# {{FEATURE}} — Flutter Test Plan

**Slug:** `{{SLUG}}`
**Updated:** {{NOW_ISO}}
**Repo:** `{{REPO_PATH}}`

> Plan for **flutter-tester**. Template-rendered and **overwritten on rerun**. Focus on **BloC**, **widget**, and **golden** tests. No integration/E2E. No backend/emulators.

## 1) Scope & Objectives
- **Goal:** validate UI/state behavior against plan & arch using deterministic tests.
- **In scope:** routes/guards, BloC reducers (pure), repositories faked, widgets, goldens, error mapping, offline UX states, a11y checks.
- **Out of scope:** network/backend calls, CI/CD, store builds, performance/stress.

## 2) Preconditions & Assumptions
- Flutter stable SDK available; `flutter test` works locally.
- App repo resolved from `.agents/config.json`.
- Feature code present per structure tree; localization configured if used.
- DTO heads/fixtures available (optional) for repo fakes.

## 3) Routes Under Test
{{ROUTES}}

| Route | Guard(s) | Deep-link | Expected |
|---|---|---|---|
| `/{{SLUG}}` | `auth`, `entitled(planTier)` | yes | renders `<{{SLUG|pascal}}Page>`; redirects when unauth/unenitled |

**Guard cases**
- unauthenticated → redirected to sign-in
- lacking entitlement → routed to paywall/billing

## 4) BloC State Model (targets)
{{BLOCS}}

**Event heads:** `Start`, `EditForm`, `Submit`, `Verify`, `Provision`, `Invite`, `Retry`, `GoOffline`, `GoOnline`
**State heads:** `idle`, `collecting`, `verifyingPayment`, `provisioning`, `inviting`, `done`, `paymentFailed`, `verificationTimeout`, `provisionError`, `inviteError`, plus offline variants.

## 5) Error Mapping (canonical)
{{ERROR_TAXONOMY}}

| Code | Expected UI |
|---|---|
| `E.SEC.DENY` | access error UI |
| `E.SUB.NOT_ACTIVE` | paywall route |
| `E.IDEMP.DUP` | success from cached outcome |
| `E.VAL.FIELD` | inline field errors |
| `E.EXT.PROVIDER` | transient error + retry |
| `E.SYS.UNEXPECTED` | generic error + retry |

## 6) Offline & Resilience
{{OFFLINE_NOTES}}

- Visual offline indicator; actions disabled appropriately.
- Submit queues `{requestId, payload}`; resume on “reconnect”.

## 7) A11y & Design System
{{A11Y_NOTES}}
{{DESIGN_SYSTEM_NOTES}}

- Semantics labels, focus order, large text, RTL; tap targets ≥ 44px; contrast ≥ 4.5:1.
- Reuse `uikit` tokens/components; no ad-hoc styles.

## 8) Test Matrix

### 8.1 BloC (pure reducers; repo faked)
| Case | Given | When | Then |
|---|---|---|---|
| Happy path | clean state | `Submit(valid)` → provider ok | `verifyingPayment → provisioning → inviting → done` |
| Provider fail | provider throws | `Submit(valid)` | `paymentFailed` (code `E.EXT.PROVIDER`) |
| Validation | missing fields | `Submit(invalid)` | `E.VAL.FIELD` + untouched effects |
| Idempotent resume | cached success | `Submit(same requestId)` | transitions to `done` without side-effects |
| Offline submit | offline flag | `Submit(valid)` | queued; state shows offline queue |
| Cross-tenant | fake returns `E.SEC.DENY` | `Submit(valid)` | state maps to access UI |

### 8.2 Widgets (pump tests)
| Case | Given | When | Then |
|---|---|---|---|
| Route allowed | auth+entitled | navigate `/{{SLUG}}` | page visible; initial state shown |
| Route denied | unauth | navigate `/{{SLUG}}` | redirected to sign-in |
| Error mapping | repo returns `E.SUB.NOT_ACTIVE` | submit | navigates to paywall |
| Form errors | invalid input | submit | inline errors displayed |
| Offline banner | offline | visit page | banner visible; actions disabled as designed |

### 8.3 Goldens (snapshots)
- States to snapshot (light/dark; at least one RTL/large text):
  `loading`, `empty`, `error(E.EXT.PROVIDER)`, `offline`, `success`.

| Widget | Variant | Golden path |
|---|---|---|
| `{{SLUG|pascal}}Page` | loading | `test/features/{{SLUG}}/golden/{{SLUG}}_loading.png` |
| … | … | … |

> Disable animations; stable fonts/DPR; no network images.

## 9) Fakes & Fixtures
**Repo fakes**
- `fake_{{SLUG}}_repo.dart` returns canned `Right/Left` with codes above.
**Fixtures**
- `test/features/{{SLUG}}/fixtures/dto_request.json`, `dto_response.json`.

## 10) Commands (local)
```bash
flutter pub get
dart format --set-exit-if-changed .
dart analyze
flutter test --update-goldens=false
```

## 11) Exit Criteria

* All matrix cases implemented and **passing**.
* All canonical error codes exercised and mapped to UX.
* Goldens updated/approved externally if visuals changed (out of scope here).
* Results written to `qa/flutter/results.md` (pass/fail, goldens, defects).

## 12) Risks & Mitigations

| Risk             | Impact      | Likelihood | Mitigation                         |
| ---------------- | ----------- | ---------: | ---------------------------------- |
| Golden flakiness | false diffs |        Med | lock fonts/DPR; disable animations |
| Guard loops      | test hangs  |        Low | use fake router; assert redirects  |
| Time-based UI    | flaky       |        Low | inject clock; fixed durations      |

## 13) Defects & Ownership (during execution)

| ID   | Sev | Title | Owner | Status |
| ---- | --: | ----- | ----- | ------ |
| DEF- |     |       |       |        |

## 14) Approval Gate

* **Approve when:** exit criteria met; **Blocker/High** defects closed or waived with sign-off.
* **Approver(s):** <name(s)>
