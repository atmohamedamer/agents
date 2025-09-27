# {{FEATURE}} — Security & Tenancy

**Slug:** `{{SLUG}}`<br/>
**Updated:** {{NOW_ISO}}

## 1) Threat Model (concise)
- **Assets:** org data, subscriptions, receipts/tokens (server-only), user identities.
- **Actors:** owner/member (authenticated), attacker (external), compromised client, misconfigured webhook.
- **Entrypoints:** client → HTTP/Callable; provider webhooks; scheduled jobs.

## 2) Tenancy Model
- **Ownership:** every document carries `orgId` (string). No shared docs across tenants.
- **Scoping rule:** all reads/writes filter or assert `orgId == token.orgId` in **both** Rules and service layer.
- **Joins/aggregations:** performed server-side only; no cross-tenant fan-out on client.

## 3) Firestore Security Rules (fragments)
```js
rules_version = '2';
service cloud.firestore {
  match /databases/{db}/documents {
    function hasAuth() {
      return request.auth != null;
    }
    function orgMatch(doc) {
      return hasAuth() && request.auth.token.orgId == doc.orgId;
    }
    function isAdmin() {
      return hasAuth() && request.auth.token.role == 'admin';
    }
    // Read scopes
    match /Organizations/{orgId} {
      allow read: if hasAuth() && request.auth.token.orgId == orgId;
      allow create: if false;             // server-only
      allow update, delete: if false;     // server-only
    }
    match /Subscriptions/{id} {
      allow read: if orgMatch(resource.data);
      allow write: if false;              // server-only via provider webhook
    }
    match /{coll}/{id} {
      allow read: if orgMatch(resource.data);
      allow create: if false;             // privileged writes via Functions
      allow update, delete: if false;
    }
  }
}
````

> Import per-feature fragments from `firestore.rules.d/{{SLUG}}.rules` in your root rules.

## 4) App Check & Auth

* **App Check:** mandatory for all client-initiated HTTP/Callable; reject missing/invalid tokens.
* **Auth:** Firebase Auth required; service enforces `orgId` & role checks on **every** mutation.
* **Token refresh:** after provisioning or claim changes, client must refresh ID token.

## 5) Claims & Entitlements

* **Custom claims:** `{ orgId, role, planTier, seatCount }` (minimal set).
* **Propagation:** claims updated server-side post-verify/provision; background token invalidation documented.
* **Server enforcement:** plan gates & seat caps in use-cases (not client); never trust client claims alone.

## 6) Server Guards (edge/service)

* **Interface (HTTP/Callable):**

  * Require Auth + App Check.
  * Validate DTOs; reject unknown fields; cap sizes.
  * Assert `payload.orgId == auth.token.orgId`.
  * Derive **idempotency key** (`requestId` or provider reference).
* **Service:**

  * Enforce role/entitlement; read subscription state from server source of truth.
  * Write via repositories with tenancy filters; never pass client-controlled paths.
* **Webhook handling:**

  * Verify signature/origin and replay protection.
  * Idempotent by `providerRef`; store outcome; return last-success on duplicate.

## 7) Data Minimization & PII

* Store only necessary provider references/last4 (if applicable); never full PAN or secrets.
* **Logs:** no PII or secrets; structured fields: `traceId`, `orgId`, `feature`, `action`, `code`, `status`, `latencyMs`.

## 8) Negative Paths (must test)

* Cross-tenant read/write attempts → **deny** (Rules + emulator tests).
* Missing/invalid App Check → **deny** at edge.
* Stale/absent claims after purchase → gated until refresh & server verification.
* Duplicate webhook/event → processed once; duplicates return cached outcome.
