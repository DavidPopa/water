# Go Debugging Guide

## Nil Pointer Dereference
- Stack trace shows exact line — check all pointer/interface values on that line
- Common: uninitialized struct field, map lookup returning zero value, unchecked error return
- Fix: add nil checks before dereference; use `if val, ok := m[key]; ok {}`

## Goroutine Leaks
- **Detect** — `runtime.NumGoroutine()` growing over time; `pprof` goroutine profile
- **Common causes** — channel with no reader/writer, blocking on context that's never cancelled
- **Fix** — always use `context.WithCancel`/`WithTimeout`; `select` with `ctx.Done()`
```bash
curl http://localhost:6060/debug/pprof/goroutine?debug=2  # Full goroutine dump
```

## Channel Deadlocks
- `fatal error: all goroutines are asleep - deadlock!` — all goroutines blocked on channel ops
- Unbuffered channel blocks until both sides ready — check sender/receiver lifecycle
- Buffered channel full — check if consumer died or is slower than producer
- **Fix** — use `select` with `default` or timeout; ensure channels are closed by producers

## Module Issues
- `go mod tidy` — clean up go.sum and go.mod
- `go mod why {module}` — trace why a dependency exists
- `go mod graph | grep {module}` — find transitive dependency path
- **Replace directives** — `go mod edit -replace old=new` for local dev overrides
- **Version conflicts** — `go list -m -json all | jq 'select(.Replace)'`

## Testing
```bash
go test ./... -v -count=1              # Verbose, no cache
go test ./... -race                     # Detect race conditions (always use in CI)
go test -run TestSpecific ./pkg/        # Run single test
go test -coverprofile=cover.out ./... && go tool cover -html=cover.out
```
- Table-driven tests: if one case fails, check index to identify which subtest
- `t.Parallel()` failures — shared state between subtests; use local copies

## Race Conditions
- `go test -race ./...` — enables race detector (2-10x slower but catches data races)
- `go build -race` — race-detecting binary for staging
- **Fix** — `sync.Mutex`, `sync.RWMutex`, channels, or `atomic` package

## Debugging with Delve
```bash
dlv debug ./cmd/server                  # Start debugger
dlv test ./pkg/ -- -run TestFoo         # Debug specific test
dlv attach <PID>                        # Attach to running process
# Inside delve: break, continue, next, step, print, goroutines, stack
```

## Profiling
```bash
# Add to main: import _ "net/http/pprof"; go http.ListenAndServe(":6060", nil)
go tool pprof http://localhost:6060/debug/pprof/profile?seconds=30  # CPU
go tool pprof http://localhost:6060/debug/pprof/heap                # Memory
go tool pprof -http=:8080 profile.out                               # Web UI
```

## Common Build Issues
- **CGO** — `CGO_ENABLED=0 go build` for static binary; issues with sqlite, etc.
- **Build tags** — `go build -tags "integration"` to include tagged files
- **Cross-compile** — `GOOS=linux GOARCH=amd64 go build`
- **Binary size** — `go build -ldflags="-s -w"` strips debug info
