# Rust Debugging Guide

## Borrow Checker Errors
- `cannot borrow as mutable because it is also borrowed as immutable` — split the borrows across different scopes or clone
- `value moved here` — use `.clone()`, pass reference `&x`, or restructure to avoid move
- `lifetime may not live long enough` — add explicit lifetime annotations; check if `'static` is needed
- `cannot return reference to local variable` — return owned type instead; use `String` not `&str`
- **Strategy** — own everything first (clone liberally), then optimize borrows once it compiles

## Unwrap / Panic
- `called unwrap() on a None/Err value` — replace `unwrap()` with `?` operator or `match`
- Stack trace: `RUST_BACKTRACE=1 cargo run` (summary) or `RUST_BACKTRACE=full` (verbose)
- **Find all unwraps** — `grep -rn "\.unwrap()" src/` and replace with proper error handling
- Use `anyhow::Result` for applications, `thiserror` for libraries

## Cargo Issues
- `cargo update` — refresh Cargo.lock to latest compatible versions
- `cargo tree -d` — show duplicate dependencies (version conflicts)
- `cargo tree -i {crate}` — show what depends on a specific crate
- **Feature conflicts** — `cargo tree -f "{p} {f}"` to see enabled features per crate
- **Workspace issues** — check `[workspace]` in root Cargo.toml; `cargo build -p {crate}`
- **Build cache corrupted** — `cargo clean && cargo build`

## Async Rust (Tokio)
- `future is not Send` — something in the async block isn't thread-safe; find the `!Send` type
  - Common: holding `MutexGuard` across `.await`; use `tokio::sync::Mutex` instead of `std::sync::Mutex`
- `future does not implement Unpin` — `Box::pin(future)` or `pin_mut!(future)`
- **Deadlock** — `tokio::sync::Mutex` inside `tokio::spawn` with nested locks; restructure
- **Tokio console** — `tokio-console` for runtime introspection of tasks and resources
- **Blocking in async** — use `tokio::task::spawn_blocking()` for CPU-heavy or sync I/O

## Common Compile Errors
- `trait bound not satisfied` — check which trait is missing; implement it or use a different approach
- `type annotations needed` — add turbofish `::<Type>` or annotate variable `let x: Type = ...`
- `size not known at compile time` — use `Box<dyn Trait>` for dynamic dispatch
- `macro expansion` errors — `cargo expand` to see generated code: `cargo install cargo-expand`

## Debugging Tools
```bash
# GDB/LLDB with Rust support
rust-gdb target/debug/myapp
rust-lldb target/debug/myapp
# Expand macros
cargo expand --lib module::name
# Memory/leak detection
cargo +nightly miri test           # Detects undefined behavior
valgrind target/debug/myapp        # Memory leak detection (Linux)
```

## Profiling
```bash
# CPU flamegraph
cargo install flamegraph
cargo flamegraph --bin myapp
# Compile time analysis
cargo build --timings              # HTML report of compile times per crate
# Binary size
cargo install cargo-bloat
cargo bloat --release --crates     # Size contribution per crate
```

## Unsafe Code Issues
- **Segfault in unsafe** — check raw pointer validity, alignment, aliasing rules
- **UB detection** — run tests under Miri: `cargo +nightly miri test`
- **FFI issues** — verify C ABI matches (`repr(C)`), null pointer checks, lifetime of pointed data
- Minimize `unsafe` blocks; wrap in safe abstractions with clear invariants
