# {{FEATURE}} — Flutter Runbook

**Slug:** `{{SLUG}}`
**Updated:** {{NOW_ISO}}
**Repo:** `{{REPO_PATH}}`

> Operational steps for **flutter-engineer**. Template-rendered and **overwritten on rerun**. Formal tests are owned by **flutter-tester**.

## 1) Preconditions
- `flutter/plan.md` approved.
- App repo resolved from `.agents/config.json` and reachable.
- Flutter SDK (stable), Dart, platform toolchains installed.
- Project lints & formatters configured (`analysis_options.yaml`).
- Backend contracts/fixtures available if needed (`.agents/{{SLUG}}/api/**`).

**Branch**
```bash
cd {{REPO_PATH}}
git checkout -b feat/{{SLUG}}
flutter --version
dart --version
````

## 2) Local setup

```bash
flutter pub get
dart format --set-exit-if-changed .
dart analyze
```

**Environment (heads)**

* Config pulled from existing app mechanism (e.g., `lib/env.dart` or flavors).
* No secrets in client. `orgId` derived from ID token at runtime.

## 3) Files to create/modify (exact paths)

```text
lib/features/{{SLUG}}/
  routes.dart                        # GoRouter routes/guards
  blocs/{{SLUG}}_bloc.dart           # events/states/reducer (pure)
  views/{{SLUG}}_page.dart           # screen shell
  views/{{SLUG}}_form.dart           # if applicable
  widgets/loading_state.dart
  widgets/error_state.dart
  widgets/empty_state.dart
  repo/{{SLUG}}_repo.dart            # abstract interface
  repo/{{SLUG}}_repo_impl.dart       # backend adapter + dto mapping
  dto/request_dto.dart
  dto/response_dto.dart
  localization/l10n_{{SLUG}}.arb     # if intl is used
```

> Presentation ↔ **BloC** ↔ Repository (data). Reducers are **pure**; side-effects live in repos.

## 4) Routes & Guards (implement)

{{ROUTES}}

**Guard heads**

* `authGuard`: require authenticated user.
* `entitlementGuard`: require plan/seat entitlement (derived from claims/server response).

```dart
// routes.dart (heads)
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/{{SLUG}}',
      name: '{{SLUG}}',
      redirect: authGuard,
      pageBuilder: (ctx, st) => const NoTransitionPage(child: {{SLUG | pascal}}Page()),
    ),
  ],
);
```

## 5) BloC (events/states)

{{BLOCS}}

```dart
// {{SLUG}}_bloc.dart (heads)
sealed class {{SLUG | pascal}}Event {}
sealed class {{SLUG | pascal}}State {}

final class Idle extends {{SLUG | pascal}}State {}
final class Collecting extends {{SLUG | pascal}}State {}
final class VerifyingPayment extends {{SLUG | pascal}}State {}
final class Provisioning extends {{SLUG | pascal}}State {}
final class Inviting extends {{SLUG | pascal}}State {}
final class Done extends {{SLUG | pascal}}State {}
final class PaymentFailed extends {{SLUG | pascal}}State { final String code; PaymentFailed(this.code); }
// reducer is pure; repo handles IO
```

## 6) Repository & DTOs

{{REPOS}}

**DTO heads**
{{DTO_HEADS}}

**Error mapping (canonical)**

| Code               | UX                               |
| ------------------ | -------------------------------- |
| `E.SEC.DENY`       | access error UI                  |
| `E.SUB.NOT_ACTIVE` | route to billing/paywall         |
| `E.IDEMP.DUP`      | show success from cached outcome |
| `E.VAL.FIELD`      | inline form errors               |
| `E.EXT.PROVIDER`   | transient message + retry        |
| `E.SYS.UNEXPECTED` | generic error + retry            |

## 7) UI States & A11y

* States rendered: **loading / empty / error / offline / success** (dedicated widgets).
* Focus order predictable; semantics labels on actionable controls.
* No hardcoded strings; use existing localization pattern if present.

**Design system**
{{DESIGN_SYSTEM_NOTES}}

**Accessibility**
{{A11Y_NOTES}}

## 8) Offline & Resilience

{{OFFLINE_NOTES}}

* Queue submit with `{requestId, payload}`; reconcile on success.
* Visual offline banner; disable transitions needing network.
