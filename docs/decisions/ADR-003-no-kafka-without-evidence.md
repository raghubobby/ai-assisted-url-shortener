# ADR-003 — Do not add Kafka without a demonstrated need

**Status:** Accepted

Click analytics is isolated so analytics persistence cannot take down redirect traffic. No requirement establishes event volume, replay, fan-out consumers, or integration needs that justify Kafka in this prototype.

Kafka remains a scale-out option when measured workload/consumer requirements justify its operational complexity.
