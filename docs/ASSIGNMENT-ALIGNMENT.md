# Assignment Alignment

| Requirement | Evidence in repository |
|---|---|
| Requirement understanding | scenario docs + AI engineering log |
| Task decomposition | each scenario contains sequenced tasks and dependencies |
| Brownfield codebase reasoning | `docs/scenarios/BROWNFIELD.md` maps the retry/idempotency problem to controllers, services, persistence, hashes, constraints, and tests |
| AI-assisted execution | scenario execution sections + AI log + prompting strategy + implementation/test/documentation artifacts |
| Traceability of generated/edited/rejected | `docs/AI-ENGINEERING-LOG.md` |
| Quality gates | JUnit, H2 app tests, PostgreSQL/Redis Testcontainers, security scripts, k6 |
| Production-quality output | Java/Spring application, API/schema, browser UI, docs |
| Risk control | failure-mode/security/trade-off docs |
| Controlled oversight | engineer-led decisions; AI does not self-approve |
| Final engineering summary | `docs/FINAL-ENGINEERING-SUMMARY.md` |
| Greenfield scenario | `docs/scenarios/GREENFIELD.md`: expiration feature with decomposition, concrete code artifacts, and validation assets |
| Brownfield scenario | `docs/scenarios/BROWNFIELD.md`: retry/idempotency enhancement with codebase reasoning, execution evidence, and regression tests |
| Ambiguous scenario | `docs/scenarios/AMBIGUOUS.md`: ambiguous “memorable” requirement clarified into the implemented custom-alias capability |
| Scenario evidence index | `docs/scenarios/README.md` |
| Runnable end-to-end | default H2 mode + browser UI |
| Setup instructions | `START-HERE.md`, `README.md`, `LOCAL-RUN-NO-DOCKER.md` |
| Testing, limitations, trade-offs | `docs/TESTING-AND-TRADEOFFS.md`, `docs/VALIDATION.md`, `docs/PERFORMANCE.md` |
