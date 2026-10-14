# Start Here

## Fastest demo

```bash
mvn -pl url-shortener spring-boot:run
```

Open **http://localhost:8082**.

This uses embedded H2 and requires no Docker, PostgreSQL, or Redis.

## What to show

1. Create a normal 7-character short link.
2. Create a custom alias with expiration.
3. Open the redirect.
4. View aggregate analytics and recent click events.
5. Deactivate the link and show `410 Gone` behavior.
6. Open `/engineering.html` or the repository docs to explain engineer-led AI usage.

## What to read before the interview

1. `README.md`
2. `docs/ARCHITECTURE.md`
3. `docs/AI-ENGINEERING-LOG.md`
4. `docs/scenarios/*`
5. `docs/INTERVIEW-TALK-TRACK.md`

## Production-like local mode

```bash
./scripts/setup-local-postgres.sh
./scripts/run-postgres.sh
```

## Scale-out demo

```bash
docker compose up --build
./scripts/demo-scale.sh
```

Scale-out UI: **http://localhost:8080**.
