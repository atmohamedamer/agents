# {{FEATURE}} — Options

<!-- RSOP:CRITERIA-BEGIN -->
## Decision Criteria & Weights (sum=100)
| Criterion | Weight | Definition |
|---|---:|---|
| Security & Tenancy | 25 | Rules/claims/App Check; cross-tenant safety |
| Fit to HLD | 20 | Clean Arch, BloC, Genkit alignment |
| Delivery Risk | 15 | Unknowns, impl complexity, regressions |
| Performance | 10 | p95 budgets; index/profile impact |
| Offline/Resilience | 10 | retries/idempotency, offline UX |
| Testability | 10 | emulators, contract tests, fixtures |
| Cost/Scope | 10 | scope blast radius, effort |
<!-- RSOP:CRITERIA-END -->

<!-- RSOP:OPTIONS-BEGIN -->
## Options
### Option A — <Title>
- **Approach:** <summary>
- **How it works (backend):** entrypoints, rules, indexes, data shapes
- **How it works (Flutter):** routes, blocs, repos, offline behavior
- **AI/Genkit (if applicable):** tools/steps/outputs
- **Pros:** <bullets>
- **Cons:** <bullets>
- **Risks & Mitigations:** <bullets>
- **Impacts:** migration/backcompat/quotas

### Option B — <Title>
<same structure>

### Option C — <Title>
<same structure>
<!-- RSOP:OPTIONS-END -->

<!-- RSOP:MATRIX-BEGIN -->
## Scoring Matrix
| Option | Security & Tenancy (25) | Fit (20) | Delivery (15) | Perf (10) | Offline (10) | Testability (10) | Cost (10) | **Total (100)** |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| A |  |  |  |  |  |  |  |  |
| B |  |  |  |  |  |  |  |  |
| C |  |  |  |  |  |  |  |  |
> Fill cells with integers; totals must sum correctly.
<!-- RSOP:MATRIX-END -->
