# Validation Record

## Repository validation layers

### Local / zero-infrastructure

```bash
mvn test
```

Runs unit tests plus the H2 full-application test.

### Production-database integration

```bash
mvn verify
```

Runs the PostgreSQL/Redis Testcontainers integration test. Requires Docker/Testcontainers support.

### Additional gates

```bash
./scripts/security-baseline.sh
./scripts/quality-gates.sh
```

### Performance

```bash
k6 run performance/k6/smoke.js
```

Additional create/redirect load assets are under `performance/k6`.

## Runtime smoke

```bash
./scripts/run-local.sh
./scripts/demo-url-shortener.sh
```

Expected flow:

create → idempotent replay → 302 redirect → aggregate analytics → detailed analytics → soft deactivation → 410.

## Scale-out smoke

```bash
docker compose up --build
./scripts/demo-scale.sh
```

The output should show `X-App-Instance` responses from both `app-1` and `app-2` over repeated requests.

## Validation principle

Do not present a test as executed unless it actually ran in that environment. In particular, H2 success is not represented as PostgreSQL compatibility evidence; the Testcontainers layer exists for that purpose.
