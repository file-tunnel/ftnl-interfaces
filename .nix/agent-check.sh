# shellcheck shell=bash
set -euo pipefail

npm test

(
  cd generated/rust
  cargo fmt --check
  cargo clippy --locked --all-targets -- -D warnings
  cargo test --locked --all-targets
)

(
  cd generated/typescript
  npm ci
  npm test
)

(
  cd generated/dart
  dart pub get
  dart format --output=none --set-exit-if-changed .
  dart analyze
  dart test
)

(
  cd generated/gleam
  gleam format --check src test
  gleam deps download
  gleam test
)
