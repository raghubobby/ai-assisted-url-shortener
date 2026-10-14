# ADR-004 — Quality evidence is independent of AI output

**Status:** Accepted

## Decision

AI can propose tests, security cases, performance checks, and review items. It cannot claim that those checks passed.

Executable validation is produced independently by:

- Java compilation/Maven
- JUnit/H2 application tests
- PostgreSQL/Redis Testcontainers integration
- security baseline scripts
- k6 threshold-based performance assets
- CI build/container validation

## Rationale

A model-generated statement such as “the tests pass” is not engineering evidence. Claims in the submission should be backed by deterministic tool output or explicitly documented as limitations/unexecuted checks.
