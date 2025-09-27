# {{FEATURE}} — Backend Required Deltas

**Slug:** `{{SLUG}}`
**Updated:** {{NOW_ISO}}
**Repo:** `{{REPO_PATH}}`

> Actionable, mechanical fixes required before approval/merge. This file is template-rendered and **overwritten on rerun**. Behavioral changes are out of scope here.

## 1) Summary
- **Verdict from review:** <approve-with-deltas | block>
- **Scope:** handlers, services, repos, Rules, Indexes, logging/metrics.

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
| 1 | High | Rules | `{{RULES_PATH}}/{{SLUG}}.rules` | Add deny-by-default; narrow allow with `orgId` check | Prevent cross-tenant access |
| 2 | High | Idempotency | `functions/src/features/{{SLUG}}/interface/http_*.ts` | Enforce idempotency key on mutate | Avoid double writes |
| 3 | Med | Index | `{{INDEXES_PATH}}/{{SLUG}}.json` | Add composite `<Coll>[fieldA,fieldB]` | Match query pattern |
| 4 | Med | Observability | `functions/src/common/logging.ts` | Include `traceId, orgId, feature, action, code, latencyMs` | Correlated diagnostics |
| 5 | Low | Code quality | `*.ts` | Remove unused imports / fix order | Lint clean |

> Add rows as needed. Keep each change small and independently verifiable.

## 3) Rules Fragment (patch head)
```diff
--- a/firestore.rules.d/{{SLUG}}.rules
+++ b/firestore.rules.d/{{SLUG}}.rules
@@
+rules_version = '2';
+service cloud.firestore {
+  match /databases/{db}/documents {
+    function authed() { return request.auth != null; }
+    function orgMatch(doc) { return authed() && request.auth.token.orgId == doc.orgId; }
+
+    match /{{Collection}}/{id} {
+      allow read: if orgMatch(resource.data);
+      allow create, update, delete: if false; // server-only
+    }
+  }
+}
````

## 4) Index Fragment (patch head)

```json
{
  "indexes": [
    {
      "collectionGroup": "{{Collection}}",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "orgId", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" }
      ]
    }
  ],
  "fieldOverrides": []
}
```

## 5) Handler Guard (patch head)

```diff
--- a/functions/src/features/{{SLUG}}/interface/http_{{SLUG}}.ts
+++ b/functions/src/features/{{SLUG}}/interface/http_{{SLUG}}.ts
@@
+ensureAuth(req);                 // 401 if missing
+ensureAppCheck(req);            // 401 if missing
+validateDto(req.body);          // strict schema
+assertOrgId(req.body.orgId, req.user.token.orgId); // 403 on mismatch
+const idempotencyKey = deriveKey(req.body.requestId);
```

## 6) Logging Fields (patch head)

```diff
--- a/functions/src/common/logging.ts
+++ b/functions/src/common/logging.ts
@@
-export function logInfo(msg: string) { ... }
+export function logInfo(ctx: Ctx, msg: string, extra: Record<string, unknown> = {}) {
+  write({
+    level: "INFO",
+    traceId: ctx.traceId,
+    orgId: ctx.orgId,
+    feature: "{{SLUG}}",
+    action: ctx.action,
+    code: ctx.code ?? null,
+    latencyMs: ctx.latencyMs ?? null,
+    ...extra
+  });
+}
```

## 7) File Moves (structure conformance)

| From                               | To                                                           | Reason               |
| ---------------------------------- | ------------------------------------------------------------ | -------------------- |
| `functions/src/{{SLUG}}.ts`        | `functions/src/features/{{SLUG}}/interface/http_{{SLUG}}.ts` | match structure tree |
| `functions/src/{{SLUG}}Service.ts` | `functions/src/features/{{SLUG}}/service/{{SLUG}}.uc.ts`     | use-case naming      |
