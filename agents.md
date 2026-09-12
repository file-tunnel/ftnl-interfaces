# File Tunnel interface agent instructions

These instructions apply to this repository and every directory beneath it.

## Repository role

- This repository is the canonical File Tunnel wire-contract source.
- Keep OpenAPI, AsyncAPI, independently authored JSON Schema and TypeSpec,
  Protobuf, fixtures, and generated Rust, TypeScript, Go, Dart, and Gleam
  snapshots behaviorally aligned.
- Neither TypeSpec nor JSON Schema may overwrite the other. Generate final
  definitions only after the pinned semantic parity gate proves agreement.
- Keep private worker models in the server scope. Browser and edge entrypoints
  must never export internal jobs, receipts, service identity, or product
  authorization projections.
- Preserve fragment-only pairing, capability separation, monotonic event
  sequencing, strict known wire fields where declared, and forward-compatible
  unknown event handling.
- Additive fields may remain in `v1`; removing fields or changing their meaning
  requires a new API version.
- Never add capabilities, pairing secrets, event tickets, local file handles,
  or file bytes to fixtures, logs, analytics contracts, or sync envelopes.

## Validation

- Run `nix develop --command agent-check` before completing a change.
- Compile TypeSpec with warnings as errors and compile every Protobuf source to
  a descriptor set; do not treat static text matching as contract validation.
- Update source contracts, fixtures, generated packages, and formal-ownership
  documentation together when a wire behavior changes.
- Never commit generated build trees or package-manager caches.

## Git workflow

- Keep changes focused and reviewable.
- Pull and merge remote work before pushing; avoid git rebase in favor of git merge.
- Never discard unrelated or uncommitted user work.

## Repository-local Git worktrees

- Create or use a Git worktree only when the human operator explicitly authorizes it for the current task. Concurrency or a dirty checkout is not permission by itself.
- Put every authorized worktree at `<repository-root>/tmp/worktrees/<name>`; from the repository root, use `./tmp/worktrees/<name>`. Never place worktrees beside repositories or organization directories.
- Keep `tmp`, `temp`, `tmp/worktrees`, and `temp/worktrees` ignored in the repository-root `.gitignore`. Do not commit files from those directories.
- Relocate or remove a worktree only when the operator explicitly requests it. Before removal, preserve and publish intended changes, verify its commit is represented on the target branch, and confirm there are no tracked, untracked, ignored-sensitive, or in-use files that must survive. Remove it with `git worktree remove <path>` without `--force`; never delete a worktree directory with `rm`.
