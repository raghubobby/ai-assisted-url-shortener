# Performance Tests

k6 assets are intentionally separated from correctness tests. They measure the service under load; they do not replace unit/integration validation.

## Targets

| Flow | Target |
|---|---:|
| Redirect p95 | < 100 ms |
| Redirect p99 | < 200 ms |
| Create p95 | < 250 ms |
| Create p99 | < 500 ms |
| HTTP failure rate | < 1% |

These are assessment/demo targets, not claims of production capacity. Real production SLOs require representative hardware, topology, traffic mix, and sustained soak tests.

## Install k6

macOS:

```bash
brew install k6
```

## Smoke

```bash
k6 run performance/k6/smoke.js
```

## Redirect load

Create a link first, then:

```bash
SHORT_CODE=<code> k6 run performance/k6/redirect-load.js
```

Against the NGINX scale-out profile:

```bash
BASE_URL=http://localhost:8080 SHORT_CODE=<code> k6 run performance/k6/redirect-load.js
```

## Create load

```bash
k6 run performance/k6/create-load.js
```
