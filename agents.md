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

<!-- BEGIN ores-agents-pointer: managed by ORESoftware/my-ai; edit there, not here -->

## Canonical agent instructions

Before doing anything else in this repository, also read:

    .ores/agents/AGENTS.md

That path is a symlink to `~/codes/oresoftware/my-ai/AGENTS.md`, whose canonical copy is
<https://github.com/ORESoftware/my-ai/blob/main/AGENTS.md>.

It exists at a fixed path *inside* the repository because some agents cannot walk up past
the repository root, so machine-wide instructions one or more directories above are
invisible to them. This pointer plus that path make the same file reachable from a working
directory anywhere in the tree.

The symlink is deliberately **not committed**: it names an absolute path that is only valid
on a machine with `~/codes/oresoftware/my-ai` checked out, so committing it would produce a
broken link for everyone else and for CI. `.ores/` is git-ignored for that reason. If
`.ores/agents/AGENTS.md` is missing on your machine, create it with:

    mkdir -p .ores/agents
    ln -sfn "$HOME/codes/oresoftware/my-ai/AGENTS.md" .ores/agents/AGENTS.md

or run `~/codes/oresoftware/my-ai/scripts/link-repo-agents.sh` once to do it for every git
repository under `~/codes`, and `--check` to verify them.

A missing `.ores/agents/AGENTS.md` is a setup gap on the reader's machine, never a reason to
skip the canonical instructions: fetch them from the URL above instead.

<!-- END ores-agents-pointer -->
