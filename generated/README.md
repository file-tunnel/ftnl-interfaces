<!-- generated-policy: frozen -->

# Generated files — read-only

Do **not** hand-edit files in this directory. They are produced by tooling such as:

- https://github.com/flags-2-env/flags-2-env (typical Dart path: `generated/dart/env.dart`)
- https://github.com/oresoftware/api-docs
- JSON Schema / OpenAPI / route-map generators in this repository

## Disk permissions

After generation, files here are frozen with `chmod a-w` (not writable). Directories
and this `README.md` stay writable so generators can replace files.

Git does **not** persist the write bit (only the executable bit). A fresh clone is
writable until you re-freeze:

```sh
find generated -type f ! -name 'README.md' ! -name 'readme.md' -exec chmod a-w {} +
```

To regenerate, edit every applicable peer authority independently. In
particular, TypeSpec and JSON Schema are both human-authored sources; neither
may be generated from the other. Run the pinned semantic parity gate before it
writes a final artifact. Preferred generators thaw, write, then `chmod a-w`
themselves.

## Gitignored trees

If `generated/` is in `.gitignore`, generated artifacts stay off VCS. Still commit
this `README.md` (`git add -f generated/README.md` or a `.gitignore` exception) so
the freeze policy is visible. Example exception:

```
generated/**
!generated/README.md
```

## Runtime contract (not just compile-time)

Unit tests validate fixtures and examples against Draft 2020-12 at runtime:
valid documents must pass and adversarial vectors must fail. TypeSpec compiles
with warnings as errors, Protobuf compiles to a descriptor set, and generated
language targets must format and compile independently. Cross-field semantic
checks remain mandatory where structural formats cannot express an invariant.
