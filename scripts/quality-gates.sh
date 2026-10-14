#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

echo "== Compile + unit/H2 application tests =="
mvn -pl url-shortener test

echo "== Security baseline =="
./scripts/security-baseline.sh

echo "== Git diff hygiene =="
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git diff --check
else
  echo "No .git directory in this archive; skipped git diff --check."
fi

echo "== k6 asset syntax =="
if command -v node >/dev/null 2>&1; then
  for f in performance/k6/*.js; do node --check "$f"; done
else
  echo "Node not installed; k6 JS syntax check skipped."
fi

echo "Local quality gates complete. Run 'mvn verify' on a Docker-capable host/CI for Testcontainers integration."
