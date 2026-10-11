
Line Spin
----

### Development

Use the compiler version in `deps.cirru` (stable Calcit 0.29.0) with the matching `@calcit/procs`. This browser dependency chain uses Phlox 0.7.13, touch-control 0.0.25 and js-ffi 0.2.1-alpha.16 releases. Phlox includes the Struct keyboard traversal and Pointed Prompt callback fixes.

```sh
caps --strict --ci
yarn install --immutable
calcit --check-only
calcit test --require-match
yarn compile
yarn dev
```

Edit `calcit.cirru` with the Calcit editor/CLI; `deps.cirru` is the dependency manifest. The obsolete `compact.cirru` snapshot and generated `js-out/` are not needed in Git.

State and operations use nominal Struct/Enum types. The dispatch boundary translates Phlox operations into the application Op, while numeric and coordinate callbacks check their payloads. Geometry has an attached regression for the original output and zero steps; no duplicated verification script is required. The original server deployment path is unchanged.

### Workflow

Workflow https://github.com/Phlox-GL/phlox-workflow

### License

MIT
