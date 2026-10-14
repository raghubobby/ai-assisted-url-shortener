#!/usr/bin/env bash
set -euo pipefail
if ! command -v psql >/dev/null 2>&1; then
  echo "psql not found. Install PostgreSQL first, e.g. brew install postgresql@16" >&2
  exit 1
fi

DB_EXISTS=$(psql postgres -tAc "SELECT 1 FROM pg_database WHERE datname='aiassist'" 2>/dev/null || true)
if [ "$DB_EXISTS" != "1" ]; then
  createdb aiassist
fi

ROLE_EXISTS=$(psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='aiassist'" 2>/dev/null || true)
if [ "$ROLE_EXISTS" != "1" ]; then
  psql postgres -v ON_ERROR_STOP=1 -c "CREATE ROLE aiassist LOGIN PASSWORD 'aiassist';"
else
  psql postgres -v ON_ERROR_STOP=1 -c "ALTER ROLE aiassist WITH LOGIN PASSWORD 'aiassist';"
fi

psql aiassist -v ON_ERROR_STOP=1 <<'SQL'
GRANT CONNECT ON DATABASE aiassist TO aiassist;
CREATE SCHEMA IF NOT EXISTS url_shortener AUTHORIZATION aiassist;
GRANT USAGE, CREATE ON SCHEMA url_shortener TO aiassist;
SQL

echo "PostgreSQL setup complete: database aiassist, schema url_shortener."
