# ADR-002 — PostgreSQL is authoritative; Redis is a non-critical cache

**Status:** Accepted

PostgreSQL owns durable short-link state, expiration/deactivation, and idempotency. Redis accelerates redirect reads only. Cache errors fall back to PostgreSQL and are observable rather than making redirect availability depend on Redis.

This keeps correctness at a transactional boundary while still demonstrating a realistic performance optimization.
