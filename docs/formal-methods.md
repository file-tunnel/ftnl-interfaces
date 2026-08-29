# Formal contract obligations

The wire contract and the executable proof have separate ownership:

| Obligation | Canonical artifact | Implementation check |
|---|---|---|
| Pairing is an atomic one-time exchange | `ftnl-backend-api.rs/formal/file_tunnel_protocol.qnt` | Rust `ProtocolState` properties and Kani |
| Capability scopes cannot cross roles | Backend Quint model and `src/protocol.rs` | HTTP handlers call the proven policy matrix |
| Event tickets are issued once and redeemed at most once | Backend Quint model | Ticket removal occurs before WebSocket upgrade |
| File states follow declared → available → downloaded | Backend Quint model | Randomized transition traces |
| Persisted mutations survive retry/reset safely | `ftnl-sync/opto-sync-clients/formal` | Rust and TypeScript ITF replay |
| Persisted progress never exceeds declared size | `ftnl-sync/adapters/rust` | Proptest and Kani |
| Pairing material stays in URI fragments | OpenAPI plus client contract | Randomized Rust client properties |
| Desktop commands apply only at the expected revision | `schema/desktop-workspace.schema.json` command envelope | Rust and Dart workspace reducer tests |
| Closing a desktop window backgrounds it unless quitting | Paired desktop feature manifest | Rust shell and Dart lifecycle state-machine tests |
| Rust and Flutter account for the same baseline features | Desktop parity fixture | Runtime schema validation and semantic manifest equality test |

The `x-file-tunnel-formal-model` extensions in OpenAPI and AsyncAPI are
machine-readable pointers, not claims that a schema validator performs model
checking. CI in the owning repositories runs the proofs.

The proof boundary deliberately excludes cryptographic strength, wall-clock
accuracy, object-store durability, malware scanning, and browser behavior.
Those require cryptographic review, fault injection, security tests, and
end-to-end automation rather than a larger state machine.

The desktop workspace schema proves only bounded shape and vocabulary. It does
not prove content-hash correctness, operating-system clipboard behavior, tray
availability, global shortcut registration, encryption, or secure deletion.
Those obligations remain in the paired applications and installed-app E2E
suites. Clipboard text is local user content and is outside all wire-contract,
telemetry, and Shared Auth proof boundaries.
