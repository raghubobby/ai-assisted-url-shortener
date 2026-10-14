# Prompting Strategy

AI assistance is most useful when the task is bounded by engineering context instead of asking for generic “best practices.”

## Prompt structure

Each meaningful task should provide:

1. **Intent** — what problem is being solved.
2. **Current context** — affected APIs/data flows/constraints.
3. **Acceptance criteria** — observable success conditions.
4. **Constraints** — compatibility, security, technology, scope.
5. **Evidence expected** — tests, diff, failure analysis, trade-offs.

## Example — brownfield bug

```text
Intent:
Fix a redirect correctness issue where stale cache state may conflict with deactivated URLs.

Context:
Spring Boot service; PostgreSQL is authoritative; Redis is optional cache-aside.

Constraints:
Do not rewrite the subsystem. Preserve API behavior. Cache failure must not reduce correctness.

Acceptance criteria:
- deactivated URLs return 410
- active URLs continue to redirect
- Redis outage falls back to DB
- regression tests cover the original failure

Output requested:
1. impacted data flow
2. smallest safe code change
3. tests
4. residual risks
```

## Iteration discipline

AI output is categorized as:

- accepted
- edited
- rejected
- re-prompted

The reason matters more than the label. `docs/AI-ENGINEERING-LOG.md` contains representative examples.
