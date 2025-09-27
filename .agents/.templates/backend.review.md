# {{FEATURE}} — Backend Review

**Slug:** `{{SLUG}}`
**Updated:** {{NOW_ISO}}
**Repo:** `{{REPO_PATH}}`

> Static/security/code review against the approved architecture and plan. Template-rendered; **overwritten on rerun**.

## 1) Summary Verdict
- **Verdict:** <approve | approve-with-deltas | block>
- **Why (1–2 lines):** <crisp rationale>
- **Scope reviewed:** handlers, services, domain, repos, Rules, Indexes, configs.

**Entry points (from code/arch):** {{ENTRYPOINTS}}

**Severity counts**
| Sev | Count | Notes |
|---|---:|---|
| **Blocker** | 0 | prevents merge |
| **High** | 0 | security/tenant/data loss |
| **Med** | 0 | correctness/perf risks |
| **Low** | 0 | style/maintainability |

## 2) Security & Tenancy
{{SECURITY_FINDINGS}}

- **Rules location:** `{{RULES_PATH}}/{{SLUG}}.rules` (imported to root: <yes/no>)
- **Tenancy enforcement:** `orgId` equality at edge + repo filters on all R/W: <yes/no>
- **App Check required** on client-originated calls: <yes/no>
- **Server-only privileged writes:** <paths confirmed>

**Top issues**
- [ ] <issue> (**sev:** High) — <why risky / fix sketch>
- [ ] <issue> (**sev:** Med) — <…>

## 3) Idempotency
{{IDEMPOTENCY_FINDINGS}}

- **Keys:** `requestId`(callables/http), `providerRef`(webhooks)
- **Store/lookup:** <collection/table>
- **Duplicate behavior:** return last-success (no extra writes): <yes/no>

**Gaps**
- [ ] Missing dedupe on `<path>` (**sev: High**)
- [ ] Outcome not persisted (**sev: Med**)

## 4) Error Taxonomy
{{ERROR_TAXONOMY_FINDINGS}}

- **Allowed codes only:** `E.SEC.DENY`, `E.SUB.NOT_ACTIVE`, `E.IDEMP.DUP`, `E.VAL.FIELD`, `E.EXT.PROVIDER`, `E.SYS.UNEXPECTED`
- **UI exposure:** messages mapped client-side; server returns **codes only**.

**Gaps**
- [ ] Non-canonical code `<code>` used (**sev: Med**)
- [ ] Leaks raw provider error (**sev: Med**)

## 5) Indexes & Queries
{{INDEX_FINDINGS}}

- **Fragments:** `{{INDEXES_PATH}}/{{SLUG}}.json` present: <yes/no>
- **Query ↔ index coverage:** <complete/partial/missing>

**Hotspots**
- [ ] Composite missing for `<collection>[fieldA, fieldB]` (**sev: High**)
- [ ] Over-indexing (bloat risk) (**sev: Low**)

## 6) Observability
{{OBSERVABILITY_FINDINGS}}

- **Structured logs:** `traceId, orgId, feature, action, code, latencyMs, idempotencyKey`
- **Metrics/traces at handlers:** <yes/no>

**Gaps**
- [ ] Missing correlation fields (**sev: Med**)
- [ ] No handler latency metric (**sev: Low**)

## 7) Code Quality & Architecture
{{CODE_QUALITY_FINDINGS}}

- **Handlers thin; services orchestrate; domain pure; data adapters isolated:** <yes/no>
- **Types & lint:** `tsc --noEmit` clean; eslint clean: <yes/no>
- **No `any` without narrowing / no dead code:** <yes/no>
- **Structure matches** `arch/structure.tree.md`: <yes/no>

**Gaps**
- [ ] Logic in handler (move to service) (**sev: Med**)
- [ ] Repo missing `orgId` filter (**sev: High**)

## 8) Required Deltas (heads)
> Detailed checklist lives in `reviews/backend-required-deltas.md`.

- [ ] Add/strengthen Rules at `<path>` (deny-by-default; narrow allow)
- [ ] Add composite index `<collection>[a,b]`
- [ ] Enforce App Check on `<handler>`
- [ ] Implement idempotency store for `<path>`
- [ ] Normalize error mapping to canonical codes
- [ ] Wire structured logging fields in `<file>`

## 9) Approval Gate
- **Approve when:** all **Blocker/High** resolved; Med/Low triaged with owners/dates.
- **Owners:** <name → area>, <name → area>
- **Target merge window:** <date>

## 10) Notes & Evidence
- Code refs: `<files/lines>`
- Architecture refs: `.agents/{{SLUG}}/arch/*`
- Observed behavior assumptions: <if any>
- Out-of-scope items: <list>
