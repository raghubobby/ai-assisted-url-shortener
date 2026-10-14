#!/usr/bin/env bash
set -euo pipefail
missing=0
for cmd in java mvn curl; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing required command: $cmd" >&2
    missing=1
  fi
done
if [ "$missing" -ne 0 ]; then
  echo "Recommended on macOS: brew install openjdk@21 maven" >&2
  exit 1
fi
java -version 2>&1 | head -n 1
mvn -version | head -n 2
if command -v psql >/dev/null 2>&1; then
  echo "PostgreSQL client: $(psql --version)"
else
  echo "PostgreSQL client: not installed (OK for default H2 mode)"
fi
if command -v redis-cli >/dev/null 2>&1 && redis-cli ping >/dev/null 2>&1; then
  echo "Redis: available"
else
  echo "Redis: not running (OK; default H2 mode and PostgreSQL fallback do not require it)"
fi
echo "Local preflight OK"
