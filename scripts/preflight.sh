#!/usr/bin/env bash
set -euo pipefail
for cmd in docker curl python3; do command -v "$cmd" >/dev/null || { echo "Missing required command: $cmd"; exit 1; }; done
docker compose version >/dev/null
echo "Preflight OK"
