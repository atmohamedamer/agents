# {{FEATURE}} — Current State

<!-- RS:SUMMARY-BEGIN -->
## Summary
<What exists today in repos/process; what the brief and plan require.>
<!-- RS:SUMMARY-END -->

<!-- RS:ARTIFACTS-BEGIN -->
## Artifacts Considered
- brief.md: <key points>
- plan.md: <key constraints from PLAN:CONSTRAINTS/NFR/INTERFACES>
- repos: <paths scanned>
- HLD: <sections used>
- external refs (if any): <links>
<!-- RS:ARTIFACTS-END -->

<!-- RS:GAPS-BEGIN -->
## Gaps vs. Target
- **Data:** <schemas/collections/indexes missing>
- **APIs:** <endpoints/callables/events missing>
- **Security/Tenancy:** <rules, claims, app check gaps>
- **Mobile/Web UX:** <flows/states/components missing>
- **Observability:** <logs/metrics/traces missing>
<!-- RS:GAPS-END -->

<!-- RS:CONSTRAINTS-BEGIN -->
## Hard Constraints (inherited)
- Multi-tenant (`orgId` everywhere, rules deny cross-tenant).
- Clean Architecture boundaries enforced.
- Flutter MVVM with **BloC**.
- Genkit flows only server-side via Functions; App Check enforced.
- Quotas/entitlements tied to subscription state.
<!-- RS:CONSTRAINTS-END -->

<!-- RS:NFR-BEGIN -->
## NFR Targets (from plan)
| Category | Target | Notes |
|---|---|---|
| Perf | p95 callable < 300ms | emulator parity |
| Security | App Check, least privilege | no PII logs |
| Tenancy | zero cross-org leakage | rules + guards |
| Offline | mobile read-friendly | queued writes |
| Observability | structured logs, codes | correlation ids |
<!-- RS:NFR-END -->

<!-- RS:QUESTIONS-BEGIN -->
## Open Questions
1) <question> — **Owner:** <name> — **Due:** <date>
<!-- RS:QUESTIONS-END -->
