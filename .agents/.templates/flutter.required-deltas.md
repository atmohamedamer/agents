# Answer

````md
# {{FEATURE}} — Flutter Required Deltas

**Slug:** `{{SLUG}}`
**Updated:** {{NOW_ISO}}
**Repo:** `{{REPO_PATH}}`

> Actionable, mechanical fixes required before approval/merge. Template-rendered; **overwritten on rerun**. No behavior/UX logic changes here.

## 1) Summary
- **Verdict from review:** <approve-with-deltas | block>
- **Scope:** routes/guards, BloCs, views/widgets, repositories/DTOs, error mapping, offline, a11y, design system, code quality.

**Severity counts**
| Sev | Count |
|---|---:|
| **Blocker** | 0 |
| **High** | 0 |
| **Med** | 0 |
| **Low** | 0 |

## 2) Checklist (atomic deltas)
| # | Sev | Area | File/Path | Change (concise) | Rationale |
|---|---:|---|---|---|---|
| 1 | High | Guard | `lib/features/{{SLUG}}/routes.dart` | Add `entitlementGuard(planTier)` to `<route>` | Prevents unauthorized access |
| 2 | Med | Error map | `lib/features/{{SLUG}}/repo/{{SLUG}}_repo_impl.dart` | Normalize codes → canonical mapping | Consistent UX |
| 3 | Med | Offline | `lib/features/{{SLUG}}/repo/{{SLUG}}_repo_impl.dart` | Persist `{requestId,payload}` until success | Idempotent resume |
| 4 | Low | L10n | `lib/l10n/*.arb` | Add missing keys `<ids>` with placeholders | No hardcoded strings |
| 5 | Low | Design system | `lib/features/{{SLUG}}/widgets/*.dart` | Replace ad-hoc colors with `uikit` tokens | Consistency |

> Add rows as needed. Keep each change small and independently verifiable.

## 3) Route/Guard Patch (head)
```diff
--- a/lib/features/{{SLUG}}/routes.dart
+++ b/lib/features/{{SLUG}}/routes.dart
@@
- GoRoute(
-   path: '/{{SLUG}}',
-   name: '{{SLUG}}',
-   pageBuilder: ...
- ),
+ GoRoute(
+   path: '/{{SLUG}}',
+   name: '{{SLUG}}',
+   redirect: entitlementGuard,
+   pageBuilder: ...
+ ),
````

## 4) Error Mapping Patch (head)

```diff
--- a/lib/features/{{SLUG}}/repo/{{SLUG}}_repo_impl.dart
+++ b/lib/features/{{SLUG}}/repo/{{SLUG}}_repo_impl.dart
@@
- final msg = resp.errorMessage; // surfaced raw
- return Left(UiError.message(msg));
+ switch (resp.code) {
+   case 'E.SEC.DENY': return Left(UiError.access());
+   case 'E.SUB.NOT_ACTIVE': return Left(UiError.paywall());
+   case 'E.IDEMP.DUP': return Right(resp.cachedOutcome);
+   case 'E.VAL.FIELD': return Left(UiError.form(resp.fieldErrors));
+   case 'E.EXT.PROVIDER': return Left(UiError.transient());
+   default: return Left(UiError.generic());
+ }
```

## 5) Offline Persistence Patch (head)

```diff
--- a/lib/features/{{SLUG}}/repo/{{SLUG}}_repo_impl.dart
+++ b/lib/features/{{SLUG}}/repo/{{SLUG}}_repo_impl.dart
@@
- Future<Result> submit(RequestDto dto) async {
-   return _api.submit(dto);
- }
+ Future<Result> submit(RequestDto dto) async {
+   await _queue.save(dto.requestId, dto);      // persist before network
+   final res = await _api.submit(dto);
+   if (res.ok) await _queue.remove(dto.requestId);
+   return res;
+ }
```

## 6) L10n Keys Patch (head)

```diff
--- a/lib/l10n/app_en.arb
+++ b/lib/l10n/app_en.arb
@@
+ "{{SLUG}}_title": "{{FEATURE}}",
+ "{{SLUG}}_error_access": "You don’t have access to this feature.",
+ "{{SLUG}}_error_generic": "Something went wrong. Try again.",
+ "{{SLUG}}_offline_banner": "You’re offline. Changes will be sent when reconnected."
```

## 7) Design System Patch (head)

```diff
--- a/lib/features/{{SLUG}}/widgets/{{SLUG}}_button.dart
+++ b/lib/features/{{SLUG}}/widgets/{{SLUG}}_button.dart
@@
- style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF2196F3))),
+ style: UiKit.button.primary, // tokenized style
```

## 8) File Moves (structure conformance)

| From                    | To                                               | Reason               |
| ----------------------- | ------------------------------------------------ | -------------------- |
| `lib/{{SLUG}}.dart`     | `lib/features/{{SLUG}}/views/{{SLUG}}_page.dart` | match structure tree |
| `lib/{{SLUG}}Bloc.dart` | `lib/features/{{SLUG}}/blocs/{{SLUG}}_bloc.dart` | naming & placement   |
