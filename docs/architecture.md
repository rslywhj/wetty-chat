# Backend Architecture

This document describes the planned backend architecture for the chat app: stack choices, transport (HTTP vs WebSockets), and how they fit together.

## Scale

- **Users:** ~20k
- **Throughput:** ~10k messages/day

Single-instance deployment is sufficient for this load.

---

## Stack

| Layer        | Choice    | Rationale |
|-------------|-----------|------------|
| **Database** | PostgreSQL | Handles users, rooms, memberships, messages. More than adequate for the target scale. |
| **Backend**  | Axum (Rust) | Async, performant, well-maintained. Fits the scale and ecosystem. |
| **API**      | REST over HTTP | Request/response (send message, list messages, CRUD). Simple, tooling-friendly, cacheable. |
| **Real-time** | WebSockets | Server → client push: new messages, typing, presence. |

---

## Transport: HTTP vs WebSockets

**Use both, with a clear split:**

| Use case | Transport | Examples |
|----------|-----------|----------|
| **Request/response** (CRUD, actions) | **HTTP (REST)** | Login, list conversations, list messages, **send message**, create room, get profile |
| **Server → client push** (real-time) | **WebSockets** | New message, typing indicator, presence, message read/delivered |

- **All API is HTTP.** Send message, list messages, create room, etc. are REST endpoints.
- **WebSockets are only for delivery and related push.** One long-lived connection per client for receiving events.

### Why not “all API via WebSockets”?

- Request/response over WebSockets means inventing an RPC envelope (message types, request IDs, errors) and losing HTTP semantics (status codes, caching, standard tooling).
- HTTP is the right tool for “do this and give me a response”; WebSockets are the right tool for “push events to the client.”

---

## Real-time model (single server)

- For ~20k users and one or two app instances, **in-process fan-out is enough**: when a message is stored, the server pushes it to connected clients in the same process (e.g. a shared registry of connection → user/conversation subscriptions).
- When scaling to **multiple app servers**, introduce a **pub/sub layer** (e.g. Redis): the server that handles the HTTP “send message” publishes an event; every app server subscribes and pushes to its own WebSocket connections. No change to the HTTP + WebSocket split; only the fan-out mechanism changes.
