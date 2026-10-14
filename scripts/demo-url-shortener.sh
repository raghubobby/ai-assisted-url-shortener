#!/usr/bin/env bash
set -euo pipefail
BASE=${URL_BASE:-http://localhost:8082}
KEY="demo-$(date +%s)"
BODY='{"url":"https://example.com/products?id=42"}'

echo "== Create =="
RESP=$(curl -fsS -X POST "$BASE/api/v1/urls" -H 'Content-Type: application/json' -H "Idempotency-Key: $KEY" -d "$BODY")
echo "$RESP" | python3 -m json.tool
CODE=$(printf '%s' "$RESP" | python3 -c 'import json,sys; print(json.load(sys.stdin)["code"])')
echo "Generated code: $CODE (length ${#CODE})"

echo "== Idempotent replay =="
curl -fsS -X POST "$BASE/api/v1/urls" -H 'Content-Type: application/json' -H "Idempotency-Key: $KEY" -d "$BODY" | python3 -m json.tool

echo "== Redirect headers =="
curl -sS -o /dev/null -D - -H 'Referer: https://search.example/results' -H 'User-Agent: curl/8.0' "$BASE/r/$CODE" | sed -n '1,12p'

echo "== Aggregate analytics =="
curl -fsS "$BASE/api/v1/urls/$CODE/analytics" | python3 -m json.tool

echo "== Detailed analytics =="
curl -fsS "$BASE/api/v1/urls/$CODE/analytics/events?limit=10" | python3 -m json.tool

echo "== Deactivate =="
curl -fsS -X DELETE "$BASE/api/v1/urls/$CODE" >/dev/null || true
STATUS=$(curl -sS -o /dev/null -w '%{http_code}' "$BASE/r/$CODE")
echo "Redirect after deactivation HTTP $STATUS (expected 410)"
