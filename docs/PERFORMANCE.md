# Performance Approach

Performance assets use k6 and are stored under `performance/k6`.

## Assessment targets

| Flow | p95 | p99 | Error rate |
|---|---:|---:|---:|
| Redirect | < 100 ms | < 200 ms | < 1% |
| Create | < 250 ms | < 500 ms | < 1% |

These are test thresholds for a controlled assessment environment, not production capacity claims.

## Why redirect is optimized separately

Redirect is the dominant read path and the primary availability/latency concern. Redis can remove repeated metadata reads while PostgreSQL remains authoritative.

## Test assets

- `smoke.js` — create + redirect correctness under k6
- `redirect-load.js` — staged redirect traffic and latency thresholds
- `create-load.js` — constant-arrival-rate write workload

## Meaningful production benchmarking would additionally require

- representative cloud/host sizing
- real network topology
- warm and cold cache runs
- mixed traffic distributions
- sustained soak tests
- DB pool/saturation analysis
- GC/JVM observations
- realistic destination/referrer mix
