# shellcheck shell=bash
set -euo pipefail

npm ci
npm test

(
  cd generated/rust
  cargo fmt --check
  cargo clippy --locked --all-targets -- -D warnings
  cargo test --locked --all-targets
)

rustfmt --edition 2024 --check \
  generated/final/rust/isomorphic/src/lib.rs \
  generated/final/rust/server/src/lib.rs
rustc --crate-name ftnl_validation_isomorphic --crate-type lib --edition 2024 \
  generated/final/rust/isomorphic/src/lib.rs \
  -o /tmp/ftnl-validation-isomorphic.rlib
rustc --crate-name ftnl_validation_server --crate-type lib --edition 2024 \
  generated/final/rust/server/src/lib.rs \
  -o /tmp/ftnl-validation-server.rlib

(
  cd generated/typescript
  npm ci
  npm test
  ./node_modules/.bin/tsc --ignoreConfig --noEmit --strict \
    --target ES2022 --module NodeNext --moduleResolution NodeNext \
    ../final/typescript/isomorphic/types.ts \
    ../final/typescript/server/types.ts \
    ../final/typescript/runtime/browser/index.ts \
    ../final/typescript/runtime/node/index.ts \
    ../final/typescript/runtime/deno/index.ts \
    ../final/typescript/runtime/bun/index.ts \
    ../final/typescript/runtime/edge/index.ts
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

gleam format --check \
  generated/final/gleam/isomorphic/src/ftnl_validation_interfaces_isomorphic.gleam \
  generated/final/gleam/server/src/ftnl_validation_interfaces_server.gleam

gofmt_output="$(
  gofmt -d \
    generated/final/golang/isomorphic/types.go \
    generated/final/golang/server/types.go
)"
if [[ -n "$gofmt_output" ]]; then
  printf '%s\n' "$gofmt_output" >&2
  exit 1
fi
GO111MODULE=off go test \
  ./generated/final/golang/isomorphic \
  ./generated/final/golang/server
