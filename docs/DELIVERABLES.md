# Assignment Deliverables Map

This page maps the assignment's five required deliverables to concrete repository evidence.

## 1. Working prototype — runnable end-to-end

### Fastest reviewer path

```bash
mvn -pl url-shortener spring-boot:run
```

Open `http://localhost:8082`.

Default mode uses embedded H2 and requires no Docker, PostgreSQL, or Redis.

### End-to-end behavior available in the product

- create generated seven-character Base62 link
- create caller-selected custom alias
- optional expiration
- direct HTTP `302` redirect
- aggregate analytics
- detailed click events
- soft deactivation
- structured `400` / `404` / `409` / `410` errors

Production-like PostgreSQL/Redis and optional NGINX/two-instance profiles are documented in the README.

## 2. Architecture overview

Primary evidence:

- [`ARCHITECTURE.md`](ARCHITECTURE.md)
- root [`README.md`](../README.md)
- [`decisions/`](decisions/) ADRs

Covered topics:

- components and tools
- create/redirect control flows
- PostgreSQL authority vs Redis cache
- idempotency and uniqueness boundaries
- analytics isolation
- runtime profiles
- horizontal scale-out
- security/observability
- key trade-offs such as deliberately not adding Kafka

## 3. Three scenarios — decomposition, execution, validation

Scenario index: [`scenarios/README.md`](scenarios/README.md)

### Greenfield — add expiring links

[`scenarios/GREENFIELD.md`](scenarios/GREENFIELD.md)

Shows:

- normalized acceptance criteria
- sequenced decomposition
- AI-assisted reasoning
- engineer decisions
- implemented artifacts across API/persistence/cache/redirect/error handling
- H2/domain validation assets and PostgreSQL/Redis validation path

### Brownfield — make create idempotent under client retries

[`scenarios/BROWNFIELD.md`](scenarios/BROWNFIELD.md)

Shows:

- existing create-path reasoning
- affected modules/data
- request fingerprinting and database uniqueness decisions
- implemented replay/conflict behavior
- save-time collision recovery
- regression/integration test evidence

### Ambiguous — “make short links more memorable”

[`scenarios/AMBIGUOUS.md`](scenarios/AMBIGUOUS.md)

Shows:

- ambiguity identification before coding
- clarification questions
- engineer-owned product definition
- revised decomposition
- implemented custom-alias capability
- validation for valid, invalid, duplicate, and default generated-code behavior

## 4. Setup instructions

Primary evidence:

- root [`START-HERE.md`](../START-HERE.md)
- root [`README.md`](../README.md)
- root [`LOCAL-RUN-NO-DOCKER.md`](../LOCAL-RUN-NO-DOCKER.md)
- scripts under [`../scripts/`](../scripts/)

Supported paths include:

- H2 zero-infrastructure local run
- standalone executable JAR
- local PostgreSQL
- PostgreSQL + Redis
- optional NGINX/two-instance scale-out

## 5. Testing approach, limitations, and trade-offs

Primary evidence:

- [`TESTING-AND-TRADEOFFS.md`](TESTING-AND-TRADEOFFS.md)
- [`VALIDATION.md`](VALIDATION.md)
- [`PERFORMANCE.md`](PERFORMANCE.md)
- [`SECURITY.md`](SECURITY.md)
- [`FAILURE-MODES.md`](FAILURE-MODES.md)

Testing layers:

1. unit/service tests
2. H2 full-application tests
3. PostgreSQL + Redis Testcontainers integration
4. security baseline checks
5. k6 threshold-based performance assets
6. CI build/integration validation

Explicit limitations/trade-offs include synchronous analytics write load, H2/PostgreSQL differences, Redis consistency boundaries, incomplete DNS-rebinding protection, and why Kafka is deferred until evidence justifies it.

## AI-assisted execution evidence

The AI-specific critical differentiator is supported by:

- [`AI-ENGINEERING-LOG.md`](AI-ENGINEERING-LOG.md)
- [`PROMPTING-STRATEGY.md`](PROMPTING-STRATEGY.md)
- the AI-assistance / engineer-decision sections inside each scenario

The repository records examples of AI recommendations that were **accepted, edited, rejected, and re-prompted**, with engineering rationale.
