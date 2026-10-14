# Testing and Trade-offs

## Layers

### Unit/service tests

Fast checks for:

- seven-character SecureRandom code generation
- target validation and normalization
- generated-code collision retry
- expiration boundary behavior in the domain model

### H2 application tests

`UrlShortenerH2Test` boots the complete Spring application with no external infrastructure and validates the reviewer path as well as scenario-specific behavior:

- generated codes match `[0-9A-Za-z]{7}`
- create → redirect → aggregate analytics → detailed analytics
- future expiration is accepted and past expiration is rejected
- same-key/same-payload idempotent replay
- same-key/different-payload conflict
- valid custom aliases
- duplicate custom-alias conflict
- invalid custom-alias syntax

This proves the zero-infrastructure developer/demo path and gives each required scenario an automated validation asset.

### PostgreSQL + Redis integration

`UrlShortenerIntegrationIT` uses Testcontainers and verifies:

- Flyway on PostgreSQL
- persistence semantics
- Redis-backed redirect path
- idempotent replay/conflict
- aggregate and detailed analytics
- deactivation followed by `410 Gone`
- unsafe-target rejection

This layer exists because H2 success is not evidence of PostgreSQL/Redis compatibility.

### Performance

k6 provides explicit threshold-based performance assets, separate from correctness tests.

## Scenario-to-test mapping

| Scenario | Primary automated evidence |
|---|---|
| Greenfield — expiration | `ShortUrlEntityTest`, `UrlShortenerH2Test#expirationContractAcceptsFutureAndRejectsPastTimestamps` |
| Brownfield — idempotent retry | `UrlShortenerH2Test#idempotencyReplaysSameRequestAndRejectsKeyReuseForDifferentPayload`, `UrlShortenerIntegrationIT#createReplayRedirectAnalyticsAndDeactivateEndToEnd`, generated-code collision unit test |
| Ambiguous — custom aliases | `UrlShortenerH2Test#customAliasValidationRejectsInvalidAndDuplicateAliases`, H2 and PostgreSQL happy-path alias creation |

## Why both H2 and Testcontainers?

H2 provides very fast zero-infrastructure feedback. It is deliberately **not** treated as a drop-in proof of PostgreSQL compatibility. Testcontainers exercises the real production database engine and Redis.

## Trade-offs

### Synchronous analytics write

Current click-event persistence is isolated from the redirect service transaction and failures are swallowed/observed so redirect availability wins. At high volume, this still adds database write load.

Production evolution: transactional outbox or streaming ingestion after traffic evidence justifies it.

### Detailed events stored in primary DB

Fine for assessment scale; an analytics warehouse/time-series store could be justified later by retention/query volume.

### No Kafka

Deliberate until throughput/replay/consumer requirements justify it.
