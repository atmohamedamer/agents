# {{FEATURE}} — Flutter Review

**Slug:** `{{SLUG}}`
**Updated:** {{NOW_ISO}}
**Repo:** `{{REPO_PATH}}`

> Static/UI/architecture review against the approved plan and arch. Template-rendered; **overwritten on rerun**.

## 1) Summary Verdict
- **Verdict:** <approve | approve-with-deltas | block>
- **Why (1–2 lines):** <crisp rationale>
- **Scope reviewed:** routes/guards, BloCs, views/widgets, repositories/DTOs, error mapping, offline, A11y, design system, performance, code quality.

**Routes (from code/arch):**
{{ROUTES}}

**Severity counts**
| Sev | Count | Notes |
|---|---:|---|
| **Blocker** | 0 | prevents merge |
| **High** | 0 | security/UX integrity |
| **Med** | 0 | correctness/perf risks |
| **Low** | 0 | style/maintainability |

## 2) Routing & Guards
{{GUARDS_FINDINGS}}

| Route | Guard(s) | Deep-link Safe | Notes |
|---|---|---|---|
| `/path` | `auth`, `entitled(planTier)` | <yes/no> | <heads>

**Gaps**
- [ ] Missing entitlement guard on `<route>` (**sev: High**)
- [ ] Redirect causes loop under `<cond>` (**sev: Med**)

## 3) BloC State Model & Purity
{{BLOC_FINDINGS}}

- **States covered:** loading / empty / error / offline / success: <complete/partial>
- **Reducers:** pure (no I/O in `mapEventToState`): <yes/no>
- **Side-effects:** isolated in repos/services: <yes/no>

**Gaps**
- [ ] Side-effect in reducer (`setState`/network) (**sev: High**)
- [ ] Unreachable state `<State>` / missing transition (**sev: Med**)

## 4) Repositories & DTO Mapping
{{REPO_DTO_FINDINGS}}

- **Interfaces:** stable, DI-friendly: <yes/no>
- **DTOs:** align with backend contracts/fixtures: <yes/no>
- **Idempotency client heads (`requestId` persistence) present:** <yes/no>

**Gaps**
- [ ] DTO mismatch for `<field>` (**sev: Med**)
- [ ] Leaks provider/internal fields to UI (**sev: Low**)

## 5) Error Mapping (canonical)
{{ERROR_MAPPING_FINDINGS}}

- **Codes → UX:**
  `E.SEC.DENY` → access UI;
  `E.SUB.NOT_ACTIVE` → paywall;
  `E.IDEMP.DUP` → show cached success;
  `E.VAL.FIELD` → inline errors;
  `E.EXT.PROVIDER` → transient + retry;
  `E.SYS.UNEXPECTED` → generic retry.

**Gaps**
- [ ] Non-canonical code `<code>` surfaced (**sev: Med**)
- [ ] Raw message shown to user (**sev: Med**)

## 6) Offline & Resilience
{{OFFLINE_FINDINGS}}

- **Behavior:** queue submit; resume on reconnect: <yes/no>
- **UI:** offline banner/state rendered: <yes/no>

**Gaps**
- [ ] No persisted `{requestId, payload}` (**sev: Med**)
- [ ] Missing retry affordance on `<state>` (**sev: Low**)

## 7) Accessibility & Design System
{{A11Y_FINDINGS}}

- **A11y:** semantics, focus order, large text, RTL, tap targets ≥ 44px, contrast ≥ 4.5:1: <pass/partial/fail>
- **Design system:** `uikit` tokens/components reused; no ad-hoc styling: <yes/no>
{{DESIGN_SYSTEM_FINDINGS}}

**Gaps**
- [ ] Missing semantics label on `<widget>` (**sev: Med**)
- [ ] Ad-hoc color bypassing tokens (**sev: Low**)

## 8) Performance
{{PERF_FINDINGS}}

- Avoid large rebuilds; keys correct; no sync I/O in build.
- Heavy lists use item builders and caching.

**Gaps**
- [ ] Rebuild of whole tree on `<event>` (**sev: Med**)
- [ ] Synchronous work in `build()` (**sev: Med**)

## 9) Code Quality & Structure
{{CODE_QUALITY_FINDINGS}}

- `dart format` clean; `dart analyze` clean: <yes/no>
- Feature folder structure matches `arch/structure.tree.md`: <yes/no>
- `const` where possible; no dead code.

**Gaps**
- [ ] File placement not matching feature structure (**sev: Low**)
- [ ] Missing `const` constructors in stateless widgets (**sev: Low**)

## 10) Required Deltas (heads)
> Detailed checklist lives in `reviews/flutter-required-deltas.md`.

- [ ] Add entitlement guard to `<route>`
- [ ] Move files to `lib/features/{{SLUG}}/...` structure
- [ ] Normalize error mapping to canonical codes
- [ ] Add missing l10n keys for `<ids>`
- [ ] Add offline queue persistence (`requestId`, payload) heads
- [ ] Replace ad-hoc styles with `uikit` tokens

## 11) Approval Gate
- **Approve when:** all **Blocker/High** resolved; Med/Low triaged with owners/dates.
- **Owners:** <name → area>, <name → area>
- **Target merge window:** <date>

## 12) Notes & Evidence
- Code refs: `<files/lines>`
- Architecture refs: `.agents/{{SLUG}}/arch/*`
- Screenshots (if any): `<paths>`
- Out-of-scope items: <list>
