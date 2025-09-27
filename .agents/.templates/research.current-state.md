# {{FEATURE}} — Current State

**Slug:** `{{SLUG}}`<br/>
**Updated:** {{NOW_ISO}}

## 1) Summary
<What exists today in code and configuration vs. what the brief/plan require. 3–6 sentences.>
- **Key facts:** <bullets of the most material realities discovered in code/infra>
- **Blocking gaps (high-level):** <bullets>

**Design refs / UI links:** {{UI_LINKS}}

## 2) Artifacts Considered
- **Brief:** `.agents/{{SLUG}}/brief.md` — <1–2 key bullets>
- **Plan:** `.agents/{{SLUG}}/plan.md` — <constraints/NFRs pulled>
- **Repos (from config):**
  {{REPO_MAP_TABLE}}
- **Code scan highlights:** {{CODE_FINDINGS}}
- **External references (top):** {{TOP_REFS}}
- **Other internal:** <HLD sections / docs used>

## 3) Code Map (today)

### Backend (Firebase/TS)
- **Entry points (HTTP/Callable):** <names + purpose>
- **Collections & ownership:** <collection names, tenancy owner, notable subcollections>
- **Security Rules coverage:** <what’s enforced; notable denies/allows; orgId checks>
- **Indexes (present/missing):** <single/composite, suspected gaps>
- **Idempotency & retries:** <patterns/keys observed>
- **Observability:** <logs/metrics/traces, error codes taxonomy>
- **App Check:** <enforced or missing paths>

### Flutter (Dart)
- **Routing (GoRouter):** <routes/guards>
- **BloC boundaries:** <feature blocs, responsibilities>
- **Repositories/DTOs:** <interfaces and data flow>
- **Offline behavior:** <cached reads/queued writes>
- **A11y states:** <loading/empty/error/offline/success coverage>
- **Tests:** <widget/golden/integration coverage hotspots>

## 4) Constraints & Assumptions (from Plan)
- **Tenancy:** multi-tenant Firestore (`orgId` on all docs); deny cross-tenant at Rules and app layer.
- **Architecture:** Clean Architecture (interface → service → domain → data); privileged writes server-side only.
- **Client:** Flutter MVVM with **BloC**; GoRouter; reuse `uikit`.
- **AI/Automation:** Genkit behind secure Cloud Functions; schema-validated IO.
- **Security:** Firebase Auth + **App Check**; least-privilege Rules; no PII logs.
- **Entitlements:** quotas/plan gates server-enforced; custom claims mirror essentials.

## 5) Gaps vs. Target
{{KEY_GAPS}}

**Data**
- Schemas missing/incorrect: <bullets>
- Expected collections/fields: <bullets>

**Interfaces**
- Handlers/events required (not present): <bullets>
- Contract diffs with plan expectations: <bullets>

**Security/Tenancy**
- Rules/claims/App Check gaps: <bullets>
- Cross-tenant risks: <bullets>

**UX**
- Missing screens/flows/states: <bullets>
- A11y/RTL gaps: <bullets>

**Observability**
- Missing logs/metrics/traces/codes: <bullets>


## 6) NFR Targets (from Plan)
| Category | Target | Current status | Hotspots / Notes |
|---|---|---|---|
| … | … | … | … |

---

## 7) Open Questions
1) <question> — **Owner:** <name> — **Due:** <date>
2) <question> — **Owner:** <name> — **Due:** <date>
