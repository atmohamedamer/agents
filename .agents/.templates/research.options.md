# {{FEATURE}} — Options

**Slug:** `{{SLUG}}`<br/>
**Updated:** {{NOW_ISO}}

> Decide among mutually exclusive, testable approaches. Keep each option concise.

## 1) Decision Criteria & Weights (sum = 100)
| Criterion | Weight | Definition |
|---|---:|---|
| Security & Tenancy | 25 | Rules/claims/App Check; zero cross-tenant leakage; least-privilege patterns |
| Fit to HLD | 20 | Clean Architecture, BloC MVVM, Genkit behind Functions, App Check posture |
| Delivery Risk | 15 | Unknowns, complexity, regressions, migration impact |
| Performance | 10 | Meets p95/p99 budgets; index/profile impact; cold-start exposure |
| Offline/Resilience | 10 | Idempotency, retries/backoff, offline UX and conflict handling |
| Testability | 10 | Emulator coverage, contract/fixture clarity, determinism |
| Cost/Scope | 10 | Effort, scope blast radius, infra/runtime cost |

> Adjust weights if needed for this feature. Weights must total **100**.

## 2) Options

### Option A — <Title>
- **Approach:** <1–2 sentences>
- **Backend (Functions/Rules/Indexes):** <entrypoints, auth/claims, indexes, idempotency>
- **Flutter (Routes/BloCs/Repos):** <screens, blocs, repos, offline behavior>
- **Genkit (if any):** <tools/flows, inputs/outputs, guardrails>
- **Pros:** <bullets>
- **Cons:** <bullets>
- **Risks & Mitigations:** <bullets; include tenancy/rules/indexes/idempotency/offline>
- **Impacts:** <migrations/back-compat/quotas/feature flags>
- **Prereqs:** <keys, configs, service accounts>

### Option B — <Title>
- **Approach:** …
- **Backend:** …
- **Flutter:** …
- **Genkit:** …
- **Pros:** …
- **Cons:** …
- **Risks & Mitigations:** …
- **Impacts:** …
- **Prereqs:** …

### Option C — <Title>
- **Approach:** …
- **Backend:** …
- **Flutter:** …
- **Genkit:** …
- **Pros:** …
- **Cons:** …
- **Risks & Mitigations:** …
- **Impacts:** …
- **Prereqs:** …

## 3) Scoring Matrix
> Score each criterion with **integers**. Multiply by weight, sum to **Total (100)** scale.

| Option | Security & Tenancy (25) | Fit (20) | Delivery (15) | Perf (10) | Offline (10) | Testability (10) | Cost (10) | **Total (100)** |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| A |  |  |  |  |  |  |  |  |
| B |  |  |  |  |  |  |  |  |
| C |  |  |  |  |  |  |  |  |

**Notes:** <any tie-breakers, assumptions, or adjustments applied>

## 4) Sensitivity Analysis
- **Most sensitive criteria:** <e.g., Security & Tenancy, Delivery Risk>
- **If weight of X ±5:** <how the ranking changes>
- **Scenario stress:** <e.g., cold-start heavy workload, spotty connectivity, partial outages>

## 5) Trade-offs Snapshot
- **A vs B:** <1 line>
- **B vs C:** <1 line>
- **A vs C:** <1 line>

## 6) Recommendation Preview (non-binding)
> Provisional pick for **architect** to validate (final choice in *Recommendation* doc):
- **Likely choice:** <Option X — Title> — because <1 sentence aligned to matrix winners>.

## 7) Open Questions
1) <question> — **Owner:** <name> — **Due:** <date>
2) <question> — **Owner:** <name> — **Due:** <date>
