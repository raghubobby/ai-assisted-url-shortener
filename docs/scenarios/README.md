# Scenario Evidence Index

The assignment asks for three scenarios—greenfield, brownfield, and ambiguous—and for each to show **decomposition, execution, and validation**.

These scenarios deliberately point to features/fixes that exist in the submitted codebase rather than hypothetical designs.

| Scenario | Requirement | Decomposition | Execution evidence | Validation evidence |
|---|---|---|---|---|
| Greenfield | Add expiring links | API → persistence → cache → redirect → errors → tests | `CreateShortUrlRequest`, `ShortUrlEntity`, `RedirectCache`, `RedirectService` | H2 tests, entity lifecycle tests, PostgreSQL/Redis integration path |
| Brownfield | Make create idempotent under client retries | header → hash → persistence → replay/conflict → concurrency | `RequestHasher`, `ShortUrlService`, DB uniqueness | replay/conflict integration test + generated-code collision regression |
| Ambiguous | “Make links memorable” | clarify → custom alias contract → validation → uniqueness | `customAlias`, alias validation, DB unique constraint, UI | H2/custom alias tests + production-like integration path |

For AI decision traceability, see [`../AI-ENGINEERING-LOG.md`](../AI-ENGINEERING-LOG.md).
