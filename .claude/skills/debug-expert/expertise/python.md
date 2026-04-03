# Python Debugging Guide

## ImportError / ModuleNotFoundError
- `pip show {package}` — verify package is installed in the right environment
- `python -c "import sys; print(sys.executable)"` — confirm which Python is active
- `python -c "import sys; print(sys.path)"` — check module search path
- Circular imports — move import inside function or restructure modules
- Relative import outside package — run with `python -m package.module` not `python file.py`

## AttributeError / TypeError
- `NoneType has no attribute` — trace back to function that returned None unexpectedly
- `object is not subscriptable` — check if variable is the type you expect: `type(x)`
- `missing required argument` — check function signature; watch for `self` in class methods
- Mutable default args — `def f(x=[])` shares list across calls; use `def f(x=None)`

## Async Issues
- `RuntimeError: no running event loop` — use `asyncio.run()` at top level, not `loop.run_until_complete()`
- `coroutine was never awaited` — missing `await` keyword
- `Event loop is closed` — create new loop or use `asyncio.new_event_loop()`
- Mixed sync/async — use `asyncio.to_thread()` for blocking calls in async context
- Debug async: `PYTHONASYNCIODEBUG=1 python app.py`

## Virtual Environment Issues
- **Wrong env active** — `which python` and `pip list` to verify
- **Poetry** — `poetry env info` shows active env; `poetry install --sync` to match lockfile
- **Conda** — `conda list` vs `pip list` conflicts; prefer one package manager
- **venv recreate** — `rm -rf .venv && python -m venv .venv && pip install -r requirements.txt`
- **pip cache issues** — `pip install --no-cache-dir {package}`

## Django Specific
- **Migration conflicts** — `python manage.py showmigrations`; merge with `python manage.py makemigrations --merge`
- **ORM N+1** — `django-debug-toolbar` or `select_related()`/`prefetch_related()`
- **Middleware order** — matters; auth before permission, session before auth
- **Template not found** — check `TEMPLATES[0]['DIRS']` and app order in `INSTALLED_APPS`
- Debug SQL: `from django.db import connection; print(connection.queries)`

## Flask Specific
- **Circular imports** — use app factory pattern; import inside functions
- **Context errors** — `with app.app_context():` for database operations outside requests
- **Debug mode** — `FLASK_DEBUG=1 flask run` (never in production)

## FastAPI Specific
- **422 Validation Error** — check request body matches Pydantic model exactly; inspect `detail` field
- **Async endpoint blocking** — use `async def` with `await`, or `def` for sync (runs in threadpool)
- **Dependency injection** — check `Depends()` chain; each dependency can fail independently
- OpenAPI docs at `/docs` — test endpoints directly there

## Type Checking
- `mypy --show-error-codes src/` — identify specific error types
- `pyright --outputjson` — machine-readable type errors
- `# type: ignore[error-code]` — suppress specific errors, not blanket ignore
- `reveal_type(x)` — add in code, mypy will print the inferred type

## Debugging Commands
```bash
# Interactive debugger
python -m pdb script.py           # Break on crash
python -c "import pdb; pdb.set_trace()"  # Manual breakpoint (or use breakpoint())
# Memory profiling
python -m memory_profiler script.py
# CPU profiling
python -m cProfile -s cumulative script.py
# Trace all calls
python -m trace --trace script.py
# Check installed packages
pip freeze | grep {name}
```

## Environment Issues
- **Python version** — `python --version`; use `pyenv` to manage versions
- **PATH precedence** — `which -a python` to see all Python binaries in PATH
- **Encoding** — `PYTHONIOENCODING=utf-8` for encoding errors
- **Segfault** — `faulthandler.enable()` at top of script; shows Python traceback on crash
- **Permission denied** — avoid `sudo pip install`; use `--user` or virtual environments
