# Ambiguous Scenario — “Make Short Links More Memorable”

## 1. Raw requirement

> Make short links easier for users to remember and share.

## 2. Why this is ambiguous

“Memorable” can mean several different products:

- automatically generate human-readable slugs from page titles
- let callers provide a vanity/custom alias
- maintain a dictionary of words
- use shorter random codes
- support branded domains
- allow users to rename an existing link

Choosing one interpretation without clarification would turn AI inference into a product/API decision.

## 3. AI-assisted requirement analysis

AI is used first to expose the ambiguity and produce clarification questions rather than code:

1. Should the service generate memorable words automatically, or should callers supply the alias?
2. Are aliases globally unique or scoped to a tenant/user?
3. What characters and maximum length are allowed?
4. What should happen when an alias is already taken?
5. Must existing generated-code behavior remain unchanged?
6. Is renaming an existing short URL in scope?

## 4. Engineer-owned clarification

The engineer makes the authoritative product decision:

> Add an **optional caller-supplied custom alias** at creation time. Aliases are globally unique for this single-tenant assessment, must be 4–32 characters using letters, digits, `_` or `-`, and return `409 Conflict` when already taken. Existing generated seven-character Base62 codes remain the default when no alias is provided. Renaming existing links is out of scope.

That clarification converts the ambiguous request into a testable engineering problem.

## 5. Revised decomposition

| Step | Engineering task | Dependency |
|---|---|---|
| 1 | Add optional `customAlias` to create contract | clarified requirement |
| 2 | Define syntax/length constraints | 1 |
| 3 | Preserve generated-code path when alias is absent | 1 |
| 4 | Enforce uniqueness in the database | 1 |
| 5 | Return structured `409 CUSTOM_ALIAS_TAKEN` on conflict | 4 |
| 6 | Add browser input and API documentation | 1–5 |
| 7 | Add positive, invalid-syntax, and duplicate-alias validation | 2–5 |

## 6. AI-assisted execution

After clarification, AI was useful for:

- drafting the alias validation rule
- identifying compatibility risk if aliases replaced generated codes rather than remaining optional
- suggesting structured conflict semantics
- generating initial validation cases
- reviewing whether alias uniqueness belongs in application logic or the database

The engineer kept uniqueness in the database and retained the existing random-code path as the default behavior.

## 7. Engineer decisions

### Decision A — alias is optional

No existing caller has to change. Without `customAlias`, the service continues producing seven-character Base62 codes.

### Decision B — narrow character allow-list

Aliases use:

```text
^[A-Za-z0-9_-]{4,32}$
```

This produces predictable path-safe identifiers without introducing URL encoding ambiguity.

### Decision C — database enforces global uniqueness

An application pre-check alone would be race-prone. The database uniqueness constraint is authoritative, and a caller-selected collision is surfaced as `409 CUSTOM_ALIAS_TAKEN`.

## 8. Execution evidence

| Artifact | Evidence |
|---|---|
| API contract | `CreateShortUrlRequest.customAlias` |
| Syntax validation | `ShortUrlService#validateAliasSyntax` |
| Optional fallback | `ShortUrlService#create` calls `ShortCodeGenerator` only when alias is absent |
| Database uniqueness | `short_url.short_code` unique constraint |
| Conflict behavior | `CUSTOM_ALIAS_TAKEN` / HTTP 409 |
| Browser UI | custom-alias field in the create form |
| API documentation | custom alias shown in `docs/API.md` |
| End-to-end happy path | H2 and PostgreSQL/Redis integration tests create caller-selected aliases |

## 9. Validation evidence

Automated validation covers:

```text
valid custom alias             -> 201 Created
no custom alias                -> generated [0-9A-Za-z]{7}
invalid alias syntax           -> 400 INVALID_REQUEST
duplicate custom alias         -> 409 CUSTOM_ALIAS_TAKEN
```

The zero-infrastructure H2 test demonstrates the custom-alias happy path, while the PostgreSQL/Redis integration test exercises the same behavior against the production-like database/cache profile.

### Commands

```bash
mvn test
```

and on a Docker-capable CI/host:

```bash
mvn clean verify
```

## 10. Why this scenario matters

The important AI behavior is **not** generating alias code quickly. It is recognizing that “memorable” is underspecified, structuring the choices, and then waiting for an engineer-owned product decision before implementation.

## 11. Final engineering outcome

The ambiguous request becomes a small backward-compatible feature with explicit API semantics, database-enforced correctness, and validation evidence. AI accelerates clarification and implementation, but the engineer owns the meaning of “memorable.”
