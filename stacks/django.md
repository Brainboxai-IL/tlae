# Django stack rules

Loaded when `framework == django`.

## Default validation chain
1. `python manage.py check`
2. `python manage.py makemigrations --dry-run --check` — fail if model changed without migration
3. `ruff check .` (if configured)
4. `python manage.py test` (or `pytest` if `pytest-django` is installed)

## Files that are Risk 2+
- `models.py` — schema changes; require a migration
- `admin.py` — surface area for staff users
- `urls.py` — public URL contract
- `settings/base.py`

## Files that are Risk 3+
- `settings/production.py` and any `*_prod.py` variant
- `migrations/` once applied — never edit; create a follow-up migration
- Any view handling auth, password reset, payments, or PII
- `manage.py` and management commands that write to DB

## Anti-patterns to refuse
- N+1 queries — flag any new `.objects.all()` followed by attribute access in a loop.
- Raw SQL with f-string interpolation of user input.
- `objects.filter(...).delete()` without explicit `confirm` flow.
- Disabling CSRF on a view "for testing".
- Storing sensitive data in `request.session` without encryption considerations.

## Migration safety
- Adding a non-nullable column on a non-empty table without `default=` AND a backfill plan → Risk 3.
- Renaming a column → don't; use add-new + deprecate-old + remove-old, three migrations.
- Dropping a column → only after confirming no code reads it.

See also `workflows/database-migration.md`.
