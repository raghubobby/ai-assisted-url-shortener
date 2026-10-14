# ADR-006 — H2 is developer convenience, not PostgreSQL compatibility evidence

## Status
Accepted.

## Decision
The default runtime uses H2 for zero-infrastructure execution. PostgreSQL compatibility is validated separately using Testcontainers.

## Rationale
A reviewer should be able to start the application immediately, but H2 does not reproduce every PostgreSQL behavior. Keeping the responsibilities explicit avoids a false validation claim.
