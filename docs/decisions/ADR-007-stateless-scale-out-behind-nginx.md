# ADR-007 — Stateless scale-out behind NGINX

## Status
Accepted as an optional demonstration profile.

## Decision
Provide NGINX plus two identical application instances sharing PostgreSQL and Redis.

## Rationale
The topology demonstrates that authoritative state is externalized and instances are horizontally replaceable. It remains optional so local reviewer experience stays simple.
