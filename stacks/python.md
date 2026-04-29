# Python stack rules

Loaded when `python` is in `languages`.

## Default validation chain
Pick the chain based on what's installed; check `pyproject.toml` first.

1. **Type check**: `mypy .` or `pyright` (only if configured)
2. **Lint/format**: `ruff check .` then `ruff format --check .` (or `black --check .` + `flake8` for older projects)
3. **Tests**: `pytest` (preferred), `python -m unittest discover`, or `python manage.py test` for Django

## Package manager priority
Detect which is in use; do not switch without approval:
- `uv` (fastest, modern) .  if `uv.lock` exists
- `poetry` .  if `poetry.lock` exists
- `pipenv` .  if `Pipfile.lock` exists
- `pip` + `requirements.txt` .  fallback

## Files that are Risk 2+
- `pyproject.toml`, `setup.cfg`, `setup.py` .  build/install behavior
- `manage.py` .  Django entry
- Any `__init__.py` that re-exports a public API
- `conftest.py` .  affects all tests in a tree

## Files that are Risk 3+
- `migrations/` .  never edit applied migrations; create new ones
- `settings.py` (Django) or `config.py` .  production config keys
- Any module that handles auth, sessions, JWTs, password hashing

## Common anti-patterns to refuse
- Adding `try/except: pass` to silence an error rather than investigating.
- Catching bare `Exception` without re-raising or logging.
- Using `print()` in production code paths.
- Mutating default args (`def f(x=[])`).
- Importing from `*` in `__init__.py`.

## Testing notes
- For Django: a model change without a migration is incomplete.
- For FastAPI: any new route should have at least one test using `TestClient`.
- For data pipelines: prefer testing the pure transformation function, not the I/O wrapper.

## Type hints
- New code in a typed project: type hints required.
- Untyped legacy project: don't introduce partial typing without a plan; ask.
