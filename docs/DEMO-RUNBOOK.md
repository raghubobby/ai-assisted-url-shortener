# Demo Runbook — 10 to 12 Minutes

## 1. Open with the assignment interpretation — 60 seconds

> “The product is the URL shortener. I used AI throughout requirement analysis, implementation, debugging, testing, documentation, and review preparation, but kept execution engineer-led. I optimized the solution for clear engineering evidence rather than autonomous orchestration.”

## 2. Product demo — 3 minutes

Run:

```bash
mvn -pl url-shortener spring-boot:run
```

Open http://localhost:8082.

Show:

1. generated seven-character link
2. custom alias + expiration
3. redirect
4. aggregate analytics
5. detailed click-event analytics
6. deactivation → subsequent `410`

## 3. Architecture — 2 minutes

Explain:

- PostgreSQL authority
- Redis cache-aside and graceful degradation
- bounded DB-backed collision retry
- idempotency key + request fingerprint
- H2 fast local mode vs PostgreSQL Testcontainers
- optional NGINX/two-instance topology

## 4. AI engineering evidence — 2 minutes

Open `docs/AI-ENGINEERING-LOG.md`.

Use the autonomous-orchestration pivot and Kafka rejection as examples of AI not being blindly followed.

## 5. Required scenarios — 2 minutes

Summarize:

- greenfield: expiration across API, persistence, cache TTL, redirect semantics, and tests
- brownfield: idempotent create under client retries, including save-time uniqueness races
- ambiguous: “make links memorable” clarified by the engineer into optional custom aliases

## 6. Validation/trade-offs — 2 minutes

Show:

- `mvn test`
- Testcontainers integration test
- k6 assets and thresholds
- failure-mode matrix
- explicit limitations

Finish with:

> “I tried to make every claim in the project either executable, evidenced, or explicitly documented as a limitation.”
