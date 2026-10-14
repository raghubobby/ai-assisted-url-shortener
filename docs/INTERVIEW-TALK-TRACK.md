# Interview Talk Track

## Why engineer-led instead of autonomous agents?

Because the assignment asks for AI-assisted engineering execution with explicit engineer ownership. AI is most useful here as a force multiplier inside bounded engineering tasks; build/test/security evidence and final decisions remain human-owned.

## Why PostgreSQL + Redis?

PostgreSQL provides durable authority and uniqueness. Redirects are read-heavy and Redis is a useful optional cache, but correctness cannot depend on it.

## Why no Kafka?

There is no measured requirement for replay, multiple independent consumers, or high event throughput. Adding Kafka would optimize for imagined scale. If analytics volume threatens redirect SLOs, I would consider a transactional outbox and asynchronous ingestion based on measurements.

## Why H2 if PostgreSQL is the real database?

Reviewer/developer velocity. H2 gives a one-command demo. It is explicitly not treated as PostgreSQL compatibility proof; Testcontainers runs the real engine.

## Why seven-character random codes?

Simple, horizontally safe generation with large address space. `SecureRandom` avoids predictable sequences; the DB unique constraint handles the rare collision race. At much larger scale I would revisit code-allocation strategy based on traffic and enumeration requirements.

## Why 302 rather than 301?

Short-link destinations may be deactivated/expired or potentially mutable in a future product. A permanent browser/proxy cache would make lifecycle control harder. 302 is the safer prototype semantic.

## How does idempotency work?

Persist a client key plus request fingerprint. Repeating the same operation returns the same result; changing the payload while reusing a key is a conflict.

## What happens if Redis goes down?

Cache operations fail open to PostgreSQL and increment cache-error metrics. Redis is not used as the availability authority.

## What would you change first for very high traffic?

Measure first. Likely areas: redirect DB/cache hit behavior, connection pools, analytics write isolation, cache TTL/invalidation strategy, and potentially asynchronous analytics ingestion. I would not start by splitting the service or adding messaging without evidence.

## What was a meaningful AI correction?

The largest was architectural: an early direction over-focused on autonomous orchestration. The latest requirement explicitly called for engineer-led AI assistance, so that architecture was discarded. That decision is documented rather than hidden.
