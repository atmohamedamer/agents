# {{FEATURE}} — Recommendation

<!-- RSREC:CHOICE-BEGIN -->
## Selected Option
**Option:** <A/B/C> — <title>
**Why:** Highest weighted score; best fit for HLD and security posture.
<!-- RSREC:CHOICE-END -->

<!-- RSREC:RATIONALE-BEGIN -->
## Rationale (high-signal)
- **Security/Tenancy:** <why safest>
- **HLD Fit:** <clean arch/BloC/Genkit alignment>
- **Delivery:** <complexity, migrations, risks>
- **Perf/Offline:** <budgets, retries/idempotency>
- **Testability:** <fixtures/emulator/tests>
<!-- RSREC:RATIONALE-END -->

<!-- RSREC:IMPACTS-BEGIN -->
## Impacts & Required Decisions
- **Schema/index changes:** <list>
- **Rules/claims updates:** <list>
- **Quotas/entitlements:** <list>
- **Feature flags:** `<flag_name>` (<default>, owner)
<!-- RSREC:IMPACTS-END -->

<!-- RSREC:NEXT-BEGIN -->
## Handoff to Architect — Entry/Exit
**Entry:** this doc + `current-state.md` + `options.md`  
**Exit (Architect):** `arch/architecture.md`, `arch/structure.tree.md`, `arch/security-and-tenancy.md`, `arch/implementation-checklist.md`
<!-- RSREC:NEXT-END -->
