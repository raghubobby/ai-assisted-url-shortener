#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"
mvn -pl url-shortener -am package -DskipTests
exec java -jar url-shortener/target/url-shortener-1.0.0.jar
