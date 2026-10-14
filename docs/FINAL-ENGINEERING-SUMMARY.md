# Final Engineering Summary

## Plan and rationale

Build a small but production-minded URL-shortener service whose engineering choices are easy to defend. Keep the product runnable with zero external infrastructure, while also providing a production-like PostgreSQL/Redis path and optional two-instance scale-out profile.

AI is used throughout engineering work but does not own execution or quality decisions.

## Delivered artifacts

- Java 21 / Spring Boot service
- browser interface
- seven-character Base62 generation
- direct redirects
- custom aliases / expiration / soft deactivation
- idempotent create semantics
- aggregate and detailed analytics
- H2 zero-infrastructure mode
- PostgreSQL + Redis production-like mode
- NGINX/two-instance scale-out profile
- Flyway migrations
- structured errors and URL safety validation
- Actuator/Micrometer observability
- JUnit/H2/Testcontainers test layers
- k6 performance assets
- architecture, API, AI, risk, scenario, demo and interview documentation
- three evidence-backed scenarios tied to implemented code: expiration (greenfield), idempotent retry handling (brownfield), and custom aliases after ambiguity clarification

## Key decisions

1. PostgreSQL is authoritative; Redis is optional cache acceleration.
2. Generated-code uniqueness is enforced by the database with bounded collision retries.
3. No Kafka until throughput/replay/consumer evidence justifies it.
4. H2 is for fast standalone execution; PostgreSQL Testcontainers provides compatibility evidence.
5. Applied Flyway migrations are immutable.
6. AI outputs are engineering proposals; deterministic evidence and engineer review own acceptance.
7. Scale-out is demonstrated without making Docker mandatory for the reviewer.

## Risks / limitations

- synchronous analytics still adds write load to the primary database
- URL validation is not a complete DNS-rebinding SSRF solution
- cache invalidation has normal distributed race considerations
- detailed analytics belong in a dedicated analytics platform at materially larger scale
- no authentication/multi-tenant model in the base implementation

## Validation approach

- unit/service tests
- H2 full-application test
- PostgreSQL/Redis Testcontainers integration
- security baseline scripts
- k6 threshold-based performance assets
- CI build and Docker image validation

## Principle

**AI accelerated analysis and implementation; the engineer remains responsible for correctness, maintainability, risk, and production readiness.**
