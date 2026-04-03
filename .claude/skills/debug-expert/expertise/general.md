# General Debugging Guide (Language-Agnostic)

## Git Bisect for Regressions
```bash
git bisect start
git bisect bad                    # Current commit is broken
git bisect good <commit-hash>     # Last known working commit
# Test each commit, then: git bisect good/bad
git bisect reset                  # When done
# Automated: git bisect run ./test-script.sh
```

## Environment Variables
- **Missing var** — `env | grep EXPECTED_VAR`; check `.env` file loaded
- **Wrong value** — `printenv VAR_NAME`; check for trailing whitespace/newlines
- **Not propagated** — `export VAR=value` (not just `VAR=value`) for child processes
- **dotenv not loaded** — check library init runs before first access

## Docker / Container Debugging
```bash
docker logs <container> --tail 100 -f       # Stream logs
docker exec -it <container> /bin/sh         # Shell into container
docker inspect <container> | jq '.[0].State' # Check state/exit code
docker network inspect bridge               # Check network config
docker stats                                # CPU/memory per container
```
- **Container exits immediately** — check entrypoint/cmd; run interactively to see error
- **Can't connect between containers** — use service names not localhost; check same network
- **Volume mount issues** — check host path exists; permissions match container user

## Database Connection Issues
- **Connection refused** — verify host:port; `nc -zv host port` to test connectivity
- **Too many connections** — check pool size; look for leaked connections (missing `.close()`)
- **Slow queries** — enable query logging; check indexes with `EXPLAIN ANALYZE`
- **Migration failures** — check migration state table; run pending migrations one at a time
- **Timeout** — increase client timeout; check for long-running locks: `SELECT * FROM pg_locks`

## API Debugging
```bash
curl -v https://api.example.com/endpoint    # Verbose with headers
curl -X POST -H "Content-Type: application/json" -d '{"key":"val"}' URL
curl -w "\nHTTP_CODE:%{http_code}\nTIME:%{time_total}s\n" URL
```
- **401** — check token expiry, header format (`Bearer` prefix), correct env
- **403** — token valid but insufficient permissions; check role/scope
- **404** — check URL path, trailing slashes, API version prefix
- **422** — request body schema mismatch; compare against API docs
- **429** — rate limited; add retry with exponential backoff
- **5xx** — server-side; check server logs, not client code

## CI/CD Failures
- **Works locally, fails in CI** — check: env vars, node/python version, OS differences
- **Cache issues** — clear CI cache; check lockfile committed
- **Permission denied** — file permissions in git (`git ls-files -s`); container user
- **Timeout** — check for hanging tests (no timeout set), network calls to external services
- **Flaky tests** — run with `--retry 3`; isolate with `--runInBand` (serial execution)

## Network Issues
- `nslookup domain.com` / `dig domain.com` — DNS resolution
- `curl -I https://domain.com` — check SSL and response headers
- `openssl s_client -connect host:443` — inspect SSL certificate
- **Proxy** — check `HTTP_PROXY`/`HTTPS_PROXY`/`NO_PROXY` env vars
- **CORS** — server must return `Access-Control-Allow-Origin` header; check preflight OPTIONS

## Race Conditions & Concurrency
- **Symptoms** — intermittent failures, different results each run, works single-threaded
- **Reproduce** — add artificial delays, increase concurrency, run in loop 100x
- **Common causes** — shared mutable state, missing locks, read-modify-write without atomicity
- **Database** — use transactions with appropriate isolation level; optimistic locking with version column

## Memory Leaks
- **Symptoms** — process memory grows over time; OOM kills
- **Pattern** — take heap snapshot, run workload, take another snapshot, compare
- **Common causes** — unbounded caches, event listener accumulation, large objects in closures
- **Quick check** — monitor RSS: `watch -n 1 'ps -o rss= -p <PID>'`
