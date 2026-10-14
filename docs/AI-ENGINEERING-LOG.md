# AI Engineering Log

This file records representative AI-assisted engineering decisions. The goal is traceability: **what AI suggested, what the engineer accepted/edited/rejected/re-prompted, and why**.

## Decision 1 — Autonomous orchestration

**Initial AI direction:** build a governed multi-agent SDLC orchestration control plane.

**Engineer decision:** **REJECTED / PIVOTED** after reviewing the latest assignment wording.

**Rationale:** the latest brief explicitly emphasizes engineer-led execution accelerated by AI, not autonomous orchestration. The product was simplified back to the URL shortener, with AI usage demonstrated through engineering artifacts and decisions.

**Outcome:** normal product UI + documented AI-assisted workflow + deterministic quality evidence.

---

## Decision 2 — Kafka for click analytics

**AI proposal:** introduce Kafka/event streaming for analytics.

**Engineer decision:** **REJECTED**.

**Rationale:** no demonstrated throughput, replay, fan-out, or multiple-consumer requirement justifies the operational cost. PostgreSQL-backed analytics is sufficient for the assessment. Streaming remains an evolution option after measurement.

---

## Decision 3 — Redis as availability authority

**AI proposal:** use Redis as the primary redirect lookup.

**Engineer decision:** **EDITED**.

**Rationale:** Redis may accelerate reads but cannot decide correctness. PostgreSQL remains authoritative. Cache failure falls back to the database.

---

## Decision 4 — Ambiguous security requirement

**Requirement:** “Make enterprise shortened links more secure.”

**AI output:** identified plausible interpretations including enumeration resistance, authenticated redirects, tenant isolation, malicious-target prevention, and analytics privacy.

**Engineer decision:** **RE-PROMPTED** after supplying authoritative product/security scope rather than allowing AI to invent requirements.

**Rationale:** threat model and backward-compatibility policy are engineering/product decisions.

---

## Decision 5 — Flyway migration correction

**Issue discovered during real local execution:** a previously applied V1 migration had been changed, causing a checksum mismatch.

**Possible shortcut:** run Flyway repair.

**Engineer decision:** **REJECTED** that shortcut. Restored V1 and introduced forward-only V2.

**Rationale:** applied versioned migrations are immutable; migration history must remain trustworthy.

---

## Decision 6 — H2 as production-equivalent validation

**AI proposal:** use H2 for simple local execution.

**Engineer decision:** **ACCEPTED WITH CONSTRAINTS**.

**Rationale:** H2 is valuable for fast, zero-infrastructure local execution, but it must not be represented as proof of PostgreSQL compatibility.

**Outcome:** H2 full-app test plus separate PostgreSQL/Redis Testcontainers integration test.

---

## Decision 7 — Database-specific analytics query

**Issue:** the first aggregate analytics approach used PostgreSQL-specific SQL syntax.

**Engineer decision:** **EDITED**.

**Rationale:** claiming H2 standalone support while using a PostgreSQL-only aggregate query would be inconsistent.

**Outcome:** seven-day aggregation moved to portable application logic; group-by dimensions use JPQL. PostgreSQL compatibility remains covered separately.

---

## Decision 8 — NGINX/two-instance topology

**AI proposal:** demonstrate horizontal scalability.

**Engineer decision:** **ACCEPTED AS AN OPTIONAL PROFILE**, not as mandatory local complexity.

**Rationale:** stateless scale-out is useful architecture evidence, but the default reviewer path should remain one-command H2 startup.

---

## Decision 9 — Quality claims

**AI assistance:** generate/refine code, tests, documentation, risk analysis, and review preparation.

**Engineer decision:** AI confidence does not count as validation.

**Rationale:** claims must be supported by compiler output, tests, security checks, performance thresholds, or explicit limitations.

---

## Decision 10 — Expiration and cache TTL

**AI proposal:** add `expiresAt` to the create contract and persist it.

**Engineer decision:** **EDITED**.

**Rationale:** persistence alone was insufficient. Expiration also had to constrain Redis TTL and be enforced on both cache-hit and database redirect paths. Otherwise a cached redirect could remain usable beyond the business expiration timestamp.

**Outcome:** `RedirectCache` caps TTL at the remaining link lifetime, `RedirectService` re-checks expiration, and expired links use `410 Gone` semantics.

---

## Decision 11 — Idempotency implementation

**AI proposal:** treat `Idempotency-Key` as the request identity.

**Engineer decision:** **EDITED**.

**Rationale:** the same key could accidentally be reused with a different payload. The key therefore cannot prove request equivalence by itself.

**Outcome:** a SHA-256 fingerprint of the normalized create request is stored with the key. Same-key/same-payload replays return the original mapping; same-key/different-payload reuse returns `409 IDEMPOTENCY_KEY_REUSED`. Database uniqueness remains the concurrency boundary.

---

## Decision 12 — “Memorable links” ambiguity

**Requirement:** “Make short links easier to remember and share.”

**AI output:** identified multiple valid interpretations—generated words, vanity aliases, branded domains, shorter random codes, and rename support.

**Engineer decision:** **RE-PROMPTED / CLARIFIED**.

**Rationale:** choosing one of those interpretations would be a product decision, not an AI implementation detail.

**Authoritative scope:** optional caller-supplied aliases, globally unique for this assessment, 4–32 characters using letters/digits/`_`/`-`, `409` on collision, and no change to the default seven-character generated-code behavior.

**Outcome:** the implemented custom-alias feature directly reflects the clarified contract and preserves backward compatibility.
