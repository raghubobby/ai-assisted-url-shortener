# Feature Checklist

| Requested capability | Status | Evidence |
|---|---|---|
| Runnable URL Shortener service and browser interface | ✅ | `url-shortener`, `static/index.html`, default H2 profile |
| Long URL shortening with seven-character Base62 codes | ✅ | `ShortCodeGenerator`, `url-shortener.code-length: 7`, H2 test |
| Direct HTTP redirects to original URLs | ✅ | `RedirectController` (`302 Found`) |
| Aggregate and detailed analytics | ✅ | `/analytics` and `/analytics/events` |
| Optional expiration, custom aliases, soft-delete | ✅ | create request + `deactivated_at` |
| Validation and structured error handling | ✅ | `TargetUrlValidator`, `ApiExceptionHandler` |
| H2 local and standalone execution | ✅ | default profile + `run-local.sh` / `run-standalone.sh` |
| PostgreSQL, Redis, NGINX, two application instances | ✅ | `docker-compose.yml`, `infra/nginx/nginx.conf` |
| Architecture and AI-assisted engineering documentation | ✅ | `docs/ARCHITECTURE.md`, `docs/AI-ENGINEERING-LOG.md`, ADRs |
| Greenfield, brownfield, ambiguous scenarios | ✅ | `docs/scenarios/` |
| Automated tests and k6 performance assets | ✅ | JUnit/H2/Testcontainers + `performance/k6/` |
