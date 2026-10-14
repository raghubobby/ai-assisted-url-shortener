#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

if ! command -v mvn >/dev/null 2>&1; then
  echo "mvn not found. Install with: brew install maven" >&2
  exit 1
fi

echo "Starting ShortPath with embedded H2 (no PostgreSQL, Redis, or Docker required)."
echo "UI: http://localhost:8082"
exec mvn -pl url-shortener spring-boot:run
