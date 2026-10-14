# Failure Modes and Risk Controls

| Failure / risk | Control | User-visible behavior |
|---|---|---|
| Generated code collision | DB unique constraint + bounded regeneration | normally transparent; terminal `409` only after retry budget exhausted |
| Custom alias collision | DB unique constraint | `409 CUSTOM_ALIAS_TAKEN` |
| Duplicate client retry | idempotency key + request hash | returns original result |
| Same idempotency key, different payload | request-hash mismatch | `409 IDEMPOTENCY_KEY_REUSED` |
| Redis outage | catch cache access failure, use PostgreSQL | redirect still works if DB is healthy |
| Stale/expired cache entry | expiration carried in cache entry; DB remains authority after miss | `410` when inactive/expired |
| Analytics write failure | isolated transaction + failure metric | redirect remains primary availability path |
| PostgreSQL outage | fail request rather than making Redis authoritative | 5xx / unavailable |
| Expired link | timestamp validation | `410` |
| Soft-deactivated link | `deactivated_at` | `410` |
| Unsafe target | normalization + allow-list/private-literal checks | `400` |
| Flyway checksum mismatch | immutable historical migrations + forward migration | startup fails safely until corrected |
| H2/PostgreSQL semantic difference | Testcontainers PostgreSQL compatibility test | CI catches production-database-specific issues |

## Design principle

A failure-control mechanism should preserve correctness first, then availability where doing so does not invent authority. This is why Redis failure falls back to PostgreSQL, while PostgreSQL failure does not fall back to Redis as the source of truth.
