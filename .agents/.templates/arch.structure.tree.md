# {{FEATURE}} — Structure Tree

**Slug:** `{{SLUG}}`<br/>
**Updated:** {{NOW_ISO}}

> High-level filesystem plan for touched/added files. Actual code lands in repos from `.agents/config.json`. Keep feature-local; reuse shared libs/components.

## 1) Frontend (Flutter)

```text
frontend/
  lib/
    features/{{SLUG}}/
      routes.dart                 # GoRouter routes/guards for this feature
      blocs/
        {{SLUG}}_bloc.dart        # events/states/reducer (pure)
        {{SLUG}}_bloc_test.dart
      views/
        {{SLUG}}_page.dart        # screen scaffold
        {{SLUG}}_form.dart        # form widgets (if applicable)
      widgets/
        loading_state.dart
        error_state.dart
        empty_state.dart
      repo/
        {{SLUG}}_repo.dart        # interface first; impl adapts DTOs
        {{SLUG}}_repo_impl.dart
        dto/
          request_dto.dart
          response_dto.dart
      a11y/
        semantics_labels.dart
  test/
    features/{{SLUG}}/
      blocs/
        {{SLUG}}_bloc_test.dart
      widgets/
        {{SLUG}}_page_test.dart
      golden/
        {{SLUG}}_states_test.dart
````

**Notes**

* One BloC per flow; side-effects in repo/services only.
* DTOs map 1:1 to server contracts; keep mappers pure.
* All states: loading/empty/error/offline/success covered in goldens.

## 2) Backend (Cloud Functions / Firebase)

```text
backend/
  functions/
    src/
      features/{{SLUG}}/
        interface/                 # HTTP/Callable/webhook adapters
          http_{{SLUG}}.ts
          callable_{{SLUG}}.ts
          webhook_provider.ts
        service/                   # use-cases (orchestrations)
          verify_payment.uc.ts
          provision_org.uc.ts
        domain/                    # entities/value objects/invariants
          organization.entity.ts
          subscription.entity.ts
          errors.ts                # error taxonomy mapping
        data/                      # Firestore repos + external clients
          org.repo.ts
          sub.repo.ts
          provider.client.ts       # e.g., Stripe/IAP, behind interface
        __tests__/                 # vitest
          verify_payment.uc.spec.ts
          rules.spec.ts
      common/
        idempotency.ts
        auth.ts
        logging.ts
    index.ts
  firestore.rules.d/
    {{SLUG}}.rules                 # feature rules fragment (imported)
  firestore.indexes.d/
    {{SLUG}}.json                  # composite index fragment(s)
  emulator/
    seeds/{{SLUG}}.seed.json
```

**Notes**

* Interface validates/auths (Auth + **App Check**), enforces idempotency, maps errors.
* Service is the only orchestrator; domain stays pure.
* Repos are tenancy-aware (filter by `orgId`); no client writes to privileged paths.

## 3) Schemas & Fixtures (agents capsule)

```text
.agents/{{SLUG}}/
  api/
    json-schemas/
      request.schema.json
      response.schema.json
    fixtures/
      happy_request.json
      happy_response.json
      error_DENY.json
```

**Notes**

* Schemas are authoritative for DTO heads used by repo mappers.
* Fixtures double as emulator/contract tests.

## 4) Observability & Config (heads)

```text
backend/functions/src/common/
  telemetry.ts         # structured logger, metrics emitters, trace helpers
  config.ts            # runtime config access (no secrets in client)
```

**Correlation fields**: `traceId`, `orgId`, `feature`, `code`.
