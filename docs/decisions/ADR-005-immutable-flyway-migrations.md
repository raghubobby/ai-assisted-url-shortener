# ADR-005: Applied Flyway migrations are immutable

## Decision
Once a versioned Flyway migration has been released or applied, its contents are never edited. Schema corrections are introduced only through a new forward migration.

## Context
`V1__url_shortener_schema.sql` originally created `request_hash` as `CHAR(64)`. Hibernate validation later required `VARCHAR(64)`. Editing V1 caused Flyway checksum validation to fail on databases where V1 had already been applied.

## Resolution
- Restore V1 byte-for-byte to its original content.
- Keep `V2__align_request_hash_type.sql` as the forward correction from `CHAR(64)` to `VARCHAR(64)`.
- Do not use `flyway repair` to conceal a source-history mismatch in normal development.

## Rationale
This preserves reproducibility, auditability, and safe upgrade behavior for existing environments.
