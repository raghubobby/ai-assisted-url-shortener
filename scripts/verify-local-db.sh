#!/usr/bin/env bash
set -euo pipefail
DB_URL=${DB_URL:-postgresql://aiassist:aiassist@localhost:5432/aiassist}
echo "Schemas:"
psql "$DB_URL" -v ON_ERROR_STOP=1 -c "select schema_name from information_schema.schemata where schema_name='url_shortener';"
echo "URL shortener tables:"
psql "$DB_URL" -v ON_ERROR_STOP=1 -c "select table_name from information_schema.tables where table_schema='url_shortener' order by 1;"
