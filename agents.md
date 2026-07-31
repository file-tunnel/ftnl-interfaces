# File Tunnel interface agent instructions

These instructions apply to this repository and every directory beneath it.

## Repository role

- This repository is the canonical File Tunnel wire-contract source.
- Keep OpenAPI, AsyncAPI, JSON Schema, fixtures, and generated Rust,
  TypeScript, Dart, and Gleam snapshots behaviorally aligned.
- Preserve fragment-only pairing, capability separation, monotonic event
  sequencing, strict known wire fields where declared, and forward-compatible
  unknown event handling.
- Additive fields may remain in `v1`; removing fields or changing their meaning
  requires a new API version.
- Never add capabilities, pairing secrets, event tickets, local file handles,
  or file bytes to fixtures, logs, analytics contracts, or sync envelopes.

## Validation

- Run `nix develop --command agent-check` before completing a change.
- Update source contracts, fixtures, generated packages, and formal-ownership
  documentation together when a wire behavior changes.
- Never commit generated build trees or package-manager caches.

## Git workflow

- Keep changes focused and reviewable.
- Pull and merge remote work before pushing; avoid git rebase in favor of git merge.
- Never discard unrelated or uncommitted user work.
