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

`schema/desktop-workspace.schema.json` is the local-process contract shared by
the Rust and Flutter desktop companions. It defines the paired feature
manifest, bounded clipboard workspace snapshot, optimistic-revision commands,
and safe result codes. The matching fixtures include both accepted documents
and negative vectors; runtime validation and a semantic parity check ensure the
two desktop feature manifests remain complete, ordered, unique, and equal.

Clipboard text in that contract is local user content, not a wire or sync
payload. It must not enter File Tunnel requests, logs, telemetry, analytics,
deep links, fixtures derived from real users, or Shared Auth decisions. Source
exclusions use SHA-256 fingerprints so raw application identifiers do not need
to cross component boundaries.

The paired desktop implementations also expose a `proximity.secure_session`
capability: an ephemeral X25519 handshake, transcript-bound HKDF-SHA256 key
schedule, explicit six-digit SAS confirmation, and directional
ChaCha20-Poly1305 frames. The layer carries only opaque Shared Auth step-up,
consented peer-information, or signed update-manifest payloads. It treats
Bluetooth as an untrusted bearer; native adapters, permissions, background
pairing, and unattended updates remain disabled until they pass the adapter
acceptance gate in the companion contract fixture.

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

## Versioning rules

- Additive fields are allowed within `v1`.
- Clients must ignore unknown object fields and event kinds.
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
