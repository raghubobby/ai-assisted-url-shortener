#!/usr/bin/env bash
set -euo pipefail
BASE=${BASE_URL:-http://localhost:8080}

echo "Checking NGINX scale-out profile at $BASE"
for i in $(seq 1 8); do
  instance=$(curl -sS -D - -o /dev/null "$BASE/actuator/health" | awk -F': ' 'tolower($1)=="x-app-instance" {gsub("\\r", "", $2); print $2}')
  printf "request %s -> %s\n" "$i" "${instance:-unknown}"
done
