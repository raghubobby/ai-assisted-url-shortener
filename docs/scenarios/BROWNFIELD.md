# Brownfield Scenario — Make Create Idempotent Under Client Retries

## 1. Problem statement

> A client times out after creating a short URL and retries the same POST. Prevent the retry from silently creating a second mapping, while also preventing the same idempotency key from being reused for a different request.

This is a brownfield reliability enhancement to an already-working create flow.

## 2. Codebase reasoning

Relevant path before the enhancement:

```text
POST /api/v1/urls
      ↓
ShortUrlController
      ↓
ShortUrlService#create
      ↓
ShortCodeGenerator
      ↓
ShortUrlRepository
      ↓
PostgreSQL
```

Affected components:

- `ShortUrlController`
- `ShortUrlService`
- `RequestHasher`
- `ShortUrlEntity`
- `ShortUrlRepository`
- Flyway schema constraints
- create-path integration tests

The main risk is not only duplicate data. A weak implementation could also return the wrong result if a client accidentally reuses an idempotency key with different input.

## 3. Decomposition

| Step | Engineering task | Dependency |
|---|---|---|
| 1 | Accept optional `Idempotency-Key` header | none |
| 2 | Normalize and bound key length | 1 |
| 3 | Create a deterministic request fingerprint | 1 |
| 4 | Persist key + request hash with uniqueness | 2, 3 |
| 5 | Return the existing result for same-key/same-payload replay | 4 |
| 6 | Return `409` for same-key/different-payload reuse | 4 |
| 7 | Handle a concurrent uniqueness race after `saveAndFlush` | 4 |
| 8 | Add regression/integration tests and document semantics | 1–7 |

## 4. AI-assisted execution

AI accelerated the investigation by:

- identifying the classic retry window after a client-side timeout
- suggesting a request fingerprint rather than relying on the idempotency key alone
- enumerating concurrency races between the pre-read and the database insert
- drafting replay/conflict test cases
- reviewing which fields must participate in the fingerprint (`url`, `customAlias`, `expiresAt`)

The engineer rejected any design that treated an idempotency key as sufficient proof that two requests were equivalent.

## 5. Engineer decisions

### Decision A — fingerprint the normalized request

`RequestHasher` computes a SHA-256 fingerprint over the normalized create request. This makes the idempotency contract explicit:

```text
same key + same request       -> replay original result
same key + different request  -> 409 IDEMPOTENCY_KEY_REUSED
```

### Decision B — database uniqueness is the final concurrency boundary

The service performs an early lookup for efficiency, but correctness does not depend on that lookup. If concurrent requests race at insert time, the unique database constraint is authoritative and the service re-reads the winning row.

### Decision C — generated-code collision is not a client error

The same brownfield review uncovered another save-time uniqueness race: two generated codes can theoretically collide. Generated-code collisions are retried with a new cryptographically random code; caller-selected alias collisions remain `409` because they are user-visible conflicts.

## 6. Execution evidence

| Artifact | Evidence |
|---|---|
| API boundary | `ShortUrlController` accepts optional `Idempotency-Key` |
| Request fingerprint | `RequestHasher` |
| Durable fields | `ShortUrlEntity.idempotencyKey` / `requestHash` |
| Uniqueness | Flyway schema + JPA unique mapping |
| Replay logic | `ShortUrlService#validateIdempotentReplay` |
| Save-time race handling | `ShortUrlService#create` catches `DataIntegrityViolationException` and re-reads/retries |
| Error contract | `IDEMPOTENCY_KEY_REUSED` mapped to HTTP 409 |
| Generated-code race regression | `ShortUrlServiceTest#retriesGeneratedCodeCollisionWithoutMakingCollisionAClientFailure` |
| End-to-end replay/conflict | `UrlShortenerIntegrationIT#createReplayRedirectAnalyticsAndDeactivateEndToEnd` |

## 7. Validation evidence

The integration test contains all three critical cases:

```text
POST key=demo-001 payload=A  -> 201, code=staffdemo
POST key=demo-001 payload=A  -> 201, same code=staffdemo
POST key=demo-001 payload=B  -> 409 IDEMPOTENCY_KEY_REUSED
```

The service-level regression test also forces the repository to fail the first generated-code insert with a uniqueness violation, then verifies the service generates a second code and succeeds rather than leaking a database error to the client.

### Commands

```bash
mvn test
```

and, for the PostgreSQL/Redis integration path:

```bash
mvn clean verify
```

## 8. Risks and trade-offs

- Idempotency records currently live as columns on the URL row; very high-volume/general-purpose APIs might move this into a dedicated idempotency table.
- The request fingerprint contract must remain stable if request normalization rules evolve.
- A retained idempotency key has lifecycle/storage implications; production retention policy should match client retry windows.

## 9. Final engineering outcome

The brownfield change improves reliability without rewriting the create subsystem. Client retries are safe, misuse is detectable, and database uniqueness remains the final source of truth under concurrency.
