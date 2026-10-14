#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

if ! command -v mvn >/dev/null 2>&1; then
  echo "mvn not found. Install with: brew install maven" >&2
  exit 1
fi
if ! command -v pg_isready >/dev/null 2>&1 || ! pg_isready -q; then
  echo "PostgreSQL is not ready. Run ./scripts/setup-local-postgres.sh first." >&2
  exit 1
fi

export SPRING_PROFILES_ACTIVE=postgres
export SHORT_URL_CACHE_ENABLED=${SHORT_URL_CACHE_ENABLED:-false}
echo "Starting ShortPath with local PostgreSQL on http://localhost:8082"
exec mvn -pl url-shortener spring-boot:run
