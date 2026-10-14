# Greenfield Scenario — Add Expiring Links

## 1. Requirement

> Allow a caller to create a short URL that automatically becomes unusable after an optional expiration timestamp.

This is treated as a greenfield feature added to the base create/redirect flow.

## 2. Requirement normalization

The requirement is more than adding an `expiresAt` field to the API. Expiration affects persistence, cache behavior, redirect semantics, validation, and backward compatibility.

### Acceptance criteria

1. `expiresAt` is optional; existing callers remain backward compatible.
2. When provided, `expiresAt` must be in the future at creation time.
3. Expiration is persisted with the short URL.
4. Redis must never keep an entry usable beyond the link's expiration time.
5. Redirecting an expired link returns `410 Gone` rather than `404 Not Found`.
6. Metadata remains available after expiration so lifecycle state is explainable.
7. The same behavior is supported in the zero-infrastructure H2 mode and the PostgreSQL profile.

## 3. Decomposition

| Step | Engineering task | Dependency |
|---|---|---|
| 1 | Extend create contract with optional `expiresAt` | none |
| 2 | Persist `expires_at` in `short_url` | 1 |
| 3 | Reject timestamps that are already expired | 1 |
| 4 | Add entity lifecycle helpers (`isExpired`, `isActive`) | 2 |
| 5 | Carry expiration through Redis cache values/TTL | 2 |
| 6 | Enforce expiration in both cache-hit and DB redirect paths | 4, 5 |
| 7 | Map inactive/expired links to structured `410 Gone` | 6 |
| 8 | Add automated validation and API documentation | 1–7 |

## 4. AI-assisted execution

AI was useful for accelerating the feature by:

- enumerating all places where expiration affects behavior rather than only the request DTO
- identifying the cache correctness risk: cache TTL must not outlive business expiration
- proposing boundary cases such as `expiresAt <= now`
- drafting initial validation/test cases
- reviewing backward compatibility for links with `expiresAt = null`

The engineer retained ownership of HTTP semantics, cache authority, and the decision to return `410 Gone` for a known but inactive resource.

## 5. Engineer decisions

### Decision A — preserve backward compatibility

`expiresAt` remains optional. Existing links remain active indefinitely unless explicitly deactivated.

### Decision B — PostgreSQL remains authoritative

Redis may accelerate redirect resolution, but expiration is durable business state. A cache entry carries `expiresAt`, and its TTL is bounded by the remaining lifetime.

### Decision C — use `410 Gone`, not `404`

An expired short code is a known resource that is no longer active. `410` communicates lifecycle state more accurately than pretending the mapping never existed.

## 6. Execution evidence

The feature exists in the submitted codebase:

| Artifact | Evidence |
|---|---|
| API contract | `CreateShortUrlRequest.expiresAt` |
| Validation | `ShortUrlService#create` rejects non-future expiration |
| Persistence | `ShortUrlEntity.expiresAt` + Flyway `expires_at` column |
| Domain lifecycle | `ShortUrlEntity#isExpired` / `isActive` |
| Cache handling | `RedirectCache` stores expiration and bounds cache TTL |
| Redirect behavior | `RedirectService` checks expiration on cache hit and DB fallback |
| Error contract | `GoneException` → `SHORT_URL_INACTIVE` / HTTP 410 |
| Browser UI | expiration control is sent as an ISO-8601 timestamp |
| API docs | `docs/API.md` documents `expiresAt` |

## 7. Validation evidence

### Automated validation assets

- `UrlShortenerH2Test` validates the application end-to-end with zero external infrastructure.
- `UrlShortenerIntegrationIT` validates the PostgreSQL/Redis profile.
- `ShortUrlEntityTest` covers expiration boundary behavior with fixed timestamps.
- H2 API tests cover future-expiration acceptance and past-expiration rejection.

### Commands

Fast local validation:

```bash
mvn test
```

PostgreSQL + Redis integration validation on a Docker-capable machine/CI runner:

```bash
mvn clean verify
```

### Expected externally observable behavior

```text
create with no expiresAt       -> 201 Created
create with future expiresAt   -> 201 Created
create with past expiresAt     -> 400 INVALID_REQUEST
redirect while active          -> 302 Found
redirect after expiration      -> 410 SHORT_URL_INACTIVE
```

## 8. Risks and trade-offs

- Application/database clocks should be kept synchronized in production.
- Very short expirations reduce cache usefulness because cache TTL is capped by link lifetime.
- The implementation keeps expired mappings and analytics for explainability rather than physically deleting them.

## 9. Final engineering outcome

The greenfield change is intentionally cross-cutting but narrow: the API, persistence, cache, redirect semantics, tests, and documentation agree on one lifecycle model without changing behavior for existing non-expiring links.
