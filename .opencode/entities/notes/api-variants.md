Just like programming language syntax, API requests and SDK designs can be structured in **all 6 possible mathematical permutations ($3! = 6$)** of **Subject (S)**, **Object (O)**, and **Action (A)**.

Here is the complete list of all 6 API design variants, their architectural patterns, and real-world examples:

---

### 1. Variant **S – A – O** (Subject → Action → Object)
* **API Pattern:** **Fluent Client SDKs / Object-Oriented APIs**
* **How it works:** The API Client (**Subject**) calls a verb method (**Action**) directed at a payload or identifier (**Object**).

```typescript
// Pattern: [SUBJECT] -> [ACTION] -> [OBJECT]

stripeClient.customers.create({ email: "user@example.com" });
// ^          ^                ^
// |          |                +-- [OBJECT]:  Target payload
// |          +------------------- [ACTION]:  Verb method
// +------------------------------ [SUBJECT]: Authenticated SDK Client instance
```
* **Best for:** Standard SDK wrappers for SaaS platforms (Stripe, Twilio, OpenAI).

---

### 2. Variant **S – O – A** (Subject → Object → Action)
* **API Pattern:** **Resource-Path SDKs / Document Builders (Firebase, OData)**
* **How it works:** The Client (**Subject**) navigates down the resource tree to locate the target item (**Object**) first, then appends the operation verb (**Action**) at the very end.

```typescript
// Pattern: [SUBJECT] -> [OBJECT] -> [ACTION]

dbClient.collection("users").doc("user_123").delete();
// ^      ^                                  ^
// |      +----------------------------------+-- [OBJECT]: Path to resource
// |                                         +-- [ACTION]: Executed last
// +-------------------------------------------- [SUBJECT]: Database client connection
```
* **Best for:** NoSQL databases, file storage APIs, and RESTful resource builders.

---

### 3. Variant **A – S – O** (Action → Subject → Object)
* **API Pattern:** **RPC (Remote Procedure Call) / AWS-Style Command APIs**
* **How it works:** The endpoint name is the verb (**Action**), which receives the tenant/client context (**Subject**) and the target resource ID (**Object**) in the payload.

```http
POST /rpc/DeleteUser HTTP/1.1    <-- [ACTION]: Endpoint is a global verb
Content-Type: application/json

{
  "tenant_id": "acme_corp",       <-- [SUBJECT]: Scope / Context
  "user_id": "usr_42"             <-- [OBJECT]:  Target resource payload
}
```
* **Best for:** Microservices, internal gRPC/JSON-RPC services, and transactional commands.

---

### 4. Variant **A – O – S** (Action → Object → Subject)
* **API Pattern:** **Data-First Functional APIs / Curried API Wrappers / GraphQL Mutations**
* **How it works:** The verb operation (**Action**) targets the data payload (**Object**) directly, while the caller context (**Subject**) is injected implicitly (via environment/currying or auth middleware).

```graphql
# Pattern: [ACTION] -> [OBJECT] -> [SUBJECT (Implicit)]

mutation {
  deleteUser(id: "usr_42") {     # [ACTION]: deleteUser, [OBJECT]: id "usr_42"
    success                       # [SUBJECT]: Injected automatically by server context
  }
}
```
```javascript
// Curried Functional API Client:
const removeUser = deleteUser("usr_42"); // Action + Object
removeUser(apiClientContext);            // Subject supplied last
```
* **Best for:** Functional programming API clients (Ramda, fp-ts) and GraphQL mutations.

---

### 5. Variant **O – A – S** (Object → Action → Subject)
* **API Pattern:** **Event-Driven Webhooks / Reactive Streams / Pipe Architectures**
* **How it works:** Raw payload data (**Object**) triggers an event type (**Action**), which is pushed to a subscribing system or webhook listener (**Subject**).

```json
// Pattern: [OBJECT] -> [ACTION] -> [SUBJECT]
// Webhook JSON Body sent over HTTP

{
  "resource": { "invoice_id": "inv_99" },  // [OBJECT]:  The domain payload
  "event_type": "invoice.paid",            // [ACTION]:  The state transition verb
  "subscriber": "accounting_service"       // [SUBJECT]: Receiving system
}
```
* **Best for:** Asynchronous message queues (Kafka, RabbitMQ), Webhook events, and RxJS HTTP streaming.

---

### 6. Variant **O – S – A** (Object → Subject → Action)
* **API Pattern:** **Declarative Query APIs (PostgREST, Hasura, SQL-over-HTTP)**
* **How it works:** The request specifies *which fields/data* to return (**Object**) first, *where to query* (**Subject/Domain**) second, and *what filters/sorting to apply* (**Action**) last.

```http
GET /users?select=id,email&status=eq.active HTTP/1.1
    ^     ^                 ^
    |     |                 +-- [ACTION]:  Filter & evaluation criteria
    |     +-------------------- [OBJECT]:  Requested fields payload
    +-------------------------- [SUBJECT]: Target table / domain scope
```
* **Best for:** Auto-generated database APIs (Hasura, Supabase/PostgREST) and complex search/filtering engines.

---

### Summary Comparison Table

| Variant | Ordering | Primary API Architecture | Example Usage |
| :--- | :--- | :--- | :--- |
| **1. S–A–O** | Subject → Action → Object | **Fluent SDKs** | `stripe.customers.create(data)` |
| **2. S–O–A** | Subject → Object → Action | **Resource Builders** | `db.doc("users/42").delete()` |
| **3. A–S–O** | Action → Subject → Object | **Classic RPC / gRPC** | `POST /DeleteUser { tenant, id }` |
| **4. A–O–S** | Action → Object → Subject | **GraphQL / Functional APIs** | `deleteUser(id)(context)` |
| **5. O–A–S** | Object → Action → Subject | **Webhooks / Event Streams** | `{ payload } -> "paid" -> Subscriber` |
| **6. O–S–A** | Object → Subject → Action | **Declarative Query APIs** | `GET /users?select=id&active=true` |
