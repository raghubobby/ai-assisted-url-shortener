#!/usr/bin/env bash
set -euo pipefail
BASE=${URL_BASE:-http://localhost:8082}
RESP=$(curl -fsS -X POST "$BASE/api/v1/urls" -H 'Content-Type: application/json' -H "Idempotency-Key: perf-$(date +%s)" -d '{"url":"https://example.com/perf"}')
CODE=$(printf '%s' "$RESP" | python3 -c 'import json,sys; print(json.load(sys.stdin)["code"])')
TMP=$(mktemp); trap 'rm -f "$TMP"' EXIT
for _ in $(seq 1 100); do curl -sS -o /dev/null -w '%{time_total}\n' "$BASE/r/$CODE" >> "$TMP"; done
python3 - "$TMP" <<'PY'
import sys
vals=sorted(float(x.strip()) for x in open(sys.argv[1]) if x.strip())
p95=vals[max(0,int(len(vals)*.95)-1)]
print(f"redirect samples={len(vals)} p95={p95*1000:.2f}ms")
if p95 > .250:
    raise SystemExit("p95 exceeds 250ms local smoke threshold")
PY
