# JavaScript/TypeScript Debugging Guide

## TypeError / ReferenceError
- `Cannot read properties of undefined` — trace back to where the object was supposed to be assigned; check optional chaining (`?.`)
- `X is not a function` — check imports (named vs default), check if value is actually a function at runtime
- `Cannot access 'X' before initialization` — temporal dead zone with `let`/`const`; check declaration order

## Async/Await Pitfalls
- Missing `await` — function returns Promise instead of value; check all async call sites
- Unhandled rejection — add `.catch()` or wrap in try/catch; run with `node --unhandled-rejections=throw`
- Parallel vs sequential — `await Promise.all([a(), b()])` not `await a(); await b();` for parallel
- `forEach` ignores async — use `for...of` loop or `Promise.all(arr.map(async ...))`

## Node.js Specific
- **Event loop blocked** — `node --prof` then `node --prof-process`; look for synchronous I/O
- **Memory leaks** — `node --inspect` then Chrome DevTools > Memory > Heap snapshot; compare snapshots
  - Common causes: global caches, event listeners not removed, closures holding refs
- **Module resolution** — `NODE_DEBUG=module node app.js` to trace resolution
- **ESM vs CJS conflicts** — check `"type": "module"` in package.json; `.mjs`/`.cjs` extensions
  - `require()` of ES module error — switch to dynamic `import()` or use CJS version
- **Segfault/crash** — `node --abort-on-uncaught-exception` + `lldb node -c core`

## TypeScript Specific
- **Type narrowing fails** — use discriminated unions or type guards; `as` casts hide bugs
- **Declaration file missing** — `npm i -D @types/{package}` or create `declarations.d.ts`
- **Strict null checks** — `tsc --strict` to find all nullable issues at once
- **Generic inference fails** — add explicit type parameters at call site
- Check generated JS: `tsc --outDir /tmp/debug --sourceMap` then inspect output

## React Specific
- **Hydration mismatch** — search for `useLayoutEffect`, `window`/`document` in SSR code path
  - Fix: wrap browser-only code in `useEffect` or dynamic import with `ssr: false`
- **Infinite re-render** — `useEffect` with object/array dep that's recreated each render; use `useMemo`
- **Stale closure** — state reads old value in callback; use ref or functional update `setState(prev => ...)`
- **Component not updating** — mutating state directly; always create new object/array
- React DevTools Profiler: identify which components re-render and why

## Next.js Specific
- **"use client" boundary** — server components can't use hooks or browser APIs
- **API route issues** — check `req.method`, ensure `NextResponse.json()` not `res.json()` in app router
- **Build vs dev differences** — always test with `next build && next start`
- **Middleware** — runs on Edge; no Node.js APIs (no `fs`, limited `crypto`)
- `NEXT_DEBUG=1 next dev` for verbose logging

## Debugging Commands
```bash
# Inspect with Chrome DevTools
node --inspect-brk app.js        # Break on first line
# Debug tests
node --inspect-brk node_modules/.bin/jest --runInBand
# Trace warnings
node --trace-warnings app.js
# Check for circular deps
npx madge --circular src/
# Find large dependencies
npx bundle-analyzer
```

## Environment Issues
- **node_modules corrupted** — `rm -rf node_modules package-lock.json && npm install`
- **Version mismatch** — `node -v`, `npm -v`; check `engines` field in package.json
- **Native addon rebuild** — `npm rebuild` or `npx node-gyp rebuild`
- **PATH issues** — `npx which {binary}` to check resolved path
- **Port in use** — `lsof -i :3000` then `kill -9 {PID}`
