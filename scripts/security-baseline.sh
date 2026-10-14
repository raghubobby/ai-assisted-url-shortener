#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"
echo "[security] checking for committed private keys / obvious credentials"
if grep -RIE --exclude-dir=.git --exclude='*.md' --exclude='security-baseline.sh' '(BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|api[_-]?key[[:space:]]*=[[:space:]]*[A-Za-z0-9_-]{16,})' url-shortener; then
  echo "Potential secret material found" >&2; exit 1
fi
echo "[security] PASS"
