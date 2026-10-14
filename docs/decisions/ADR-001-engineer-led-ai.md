# ADR-001 — Engineer-led AI assistance, not autonomous orchestration

**Status:** Accepted

## Decision

Do not build an autonomous workflow/DAG engine for the final submission. AI is used explicitly by the engineer for bounded tasks such as requirement analysis, implementation assistance, debugging, test generation, documentation, and review preparation.

Representative accepted/edited/rejected/re-prompted decisions are retained in version-controlled engineering documentation.

## Why

The latest assignment positions AI as an accelerator inside engineer-led execution. An autonomous scheduler would be technically interesting but misaligned and would reduce visibility into engineering judgment and output ownership.

## Consequences

- product architecture stays focused on the URL shortener
- human reasoning remains visible in the AI engineering log and ADRs
- AI does not self-approve, merge, deploy, or declare production readiness
- deterministic tools provide validation evidence independent of model confidence
