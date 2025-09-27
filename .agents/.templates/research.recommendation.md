# {{FEATURE}} — Recommendation

**Slug:** `{{SLUG}}`<br/>
**Updated:** {{NOW_ISO}}

> Final, defensible pick grounded in the Options matrix and code/plan constraints.

## 1) Selected Option
**Option:** <A/B/C> — <title>
**Score (from matrix):** <total/100>
**Why now:** <1–2 sentences tying to user value / risk reduction>

## 2) Rationale (mapped to criteria)
- **Security & Tenancy (25):** <Rules/claims/App Check posture; cross-tenant guarantees>
- **Fit to HLD (20):** <Clean Architecture, BloC MVVM, Genkit-behind-Functions alignment>
- **Delivery Risk (15):** <complexity, unknowns, migration cost; why acceptable>
- **Performance (10):** <p95/p99 outlook; index strategy; cold-start mitigation>
- **Offline/Resilience (10):** <idempotency keys, retries/backoff, offline UX/conflicts>
- **Testability (10):** <emulator coverage, fixtures/contracts, determinism>
- **Cost/Scope (10):** <effort, blast radius, runtime/integrations>

> Tie-breakers & assumptions: <brief bullet(s) if two options were close>

## 3) Impacts & Required Decisions
- **Schema/index changes:** <collections/fields; composite indexes to add>
- **Security Rules/claims:** <new rules/conditions; custom claims propagation>
- **Quotas/entitlements:** <plan gates, limits, enforcement points>
- **Feature flags:** `<flag_name>` (<default>, owner)
- **Integrations:** <Stripe/IAP/other> — configs, webhooks, sandbox receipts
- **Deprecations/migrations:** <any data or API deprecations + path>

## 4) Execution Guidance (high-signal)
- **Backend (Functions/Rules):** <entrypoints, DTO heads, idempotency key, error taxonomy heads>
- **Flutter (Routes/BloCs/Repos):** <screens, blocs, repo contracts, offline behavior>
- **Genkit (if applicable):** <tools/flows, guardrails, input/output schemas>
- **Indexes (must-have):** <list>
- **Observability:** <logs/metrics/traces; correlation fields: traceId, orgId, feature, code>

## 5) Rollout & Safeguards
- **Phasing:** <dev → staging → 1% → 25% → 100% with health checks>
- **Kill-switch:** `<flag_name>` disables <scope>
- **Backout:** <how to revert Rules/indexes/contracts safely>
- **Data safety:** <backfill, migration scripts, validation>

## 6) Residual Risks & Mitigations
| Risk | Impact | Likelihood | Mitigation |
|---|---|---:|---|
| <e.g., index bloat> | High | Med | pre-create composites; contract tests |
| <…> | <…> | <…> | <…> |

## 7) Open Questions
1) <question> — **Owner:** <name> — **Due:** <date>
2) <question> — **Owner:** <name> — **Due:** <date>

## 9) References (top)
{{TOP_REFS}}
