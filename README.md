# ftnl-interfaces

Canonical, versioned contracts for [File Tunnel](https://github.com/file-tunnel).
These definitions are shared by the Rust services, mobile upload portal, native
UI components, and SDKs.

## Sources of truth

- `openapi/ftnl.openapi.yaml` defines the HTTP control and data plane.
- `asyncapi/ftnl.asyncapi.yaml` defines the realtime event stream.
- `schema/*.schema.json` defines runtime-validatable payloads.
- `fixtures/` contains cross-language contract vectors.
- `generated/` contains reviewable Rust, TypeScript, Dart, and Gleam snapshots.

The initial API is deliberately capability-based. A desktop capability can
observe and download from one tunnel; a phone capability can declare and upload
files to that tunnel. Pairing secrets are one-time credentials and should live
in the URL fragment (`#c=...`), which browsers do not send in HTTP requests.

## Core lifecycle

1. A desktop creates a tunnel and renders `pairing_uri` as a QR code.
2. A phone opens the portal and exchanges the fragment secret once.
3. The phone declares a file, uploads it, and emits progress transitions.
4. The desktop receives the same transitions over the event channel.
5. Completion, cancellation, expiry, or explicit deletion closes the tunnel.

Tunnel identifiers are routing identifiers, not credentials. Possession of a
UUID alone grants no access.

## Proximity and desktop parity

`schema/proximity.schema.json` defines a transport-neutral Bluetooth/Nearby
contract. Discovery identifiers and X25519 keys are ephemeral, the user verifies
a short authentication string, and application payloads travel only in bounded,
ordered AEAD frames. Bluetooth proximity, RSSI, and OS pairing are transport
evidence rather than identity or authentication assurance.

The Shared Auth payload carries one opaque, single-use step-up request bound by
Shared Auth to its issuer, audience, recipient, and expiry. Passwords, OTPs,
factor proofs, bearer tokens, approval results, and assurance claims do not
travel over proximity; the relying application obtains and verifies the result
over its normal authenticated channel. Peer information requires explicit
review before import. Update offers contain signed HTTPS manifest metadata only,
including App Store and TestFlight distribution hints, never raw application
binaries or silent-install instructions.

`schema/desktop-companion.schema.json` requires every shared desktop contract
change to record evidence for both Rust and Flutter. A side may be marked
`not_affected` or `blocked` only with a rationale and expiring review date;
blocked work also requires a GitHub issue. The current proximity parity record
is `fixtures/desktop-companion-proximity-v1.json`.

## Versioning rules

- Additive fields are allowed within `v1` only after schemas, fixtures, and all
  generated bindings are updated together.
- Runtime objects are closed and reject unknown fields; event `kind` values
  remain forward-compatible strings.
- Removing or changing field meaning requires a new API version.
- Capabilities, pairing secrets, and event tickets are never logged or placed
  in analytics payloads.
- File bytes are never part of sync envelopes; only upload intent and
  resumability metadata may be persisted.

## Validate

```bash
nix develop --command agent-check
```

The checked-in Nix lock pins Node.js, Rust, Dart, Gleam, Erlang, and repository
linting tools so generated bindings can be checked from one shell.
OpenAPI and AsyncAPI include machine-readable pointers to the owning executable
models; [`docs/formal-methods.md`](docs/formal-methods.md) maps each contract
obligation to its proof and implementation check.

All contents are licensed under MIT.
