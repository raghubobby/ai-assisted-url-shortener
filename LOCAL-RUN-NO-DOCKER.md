# Local Run Without Docker

The default application profile is intentionally zero-infrastructure.

## H2 quick start

```bash
brew install openjdk@21 maven
mvn -pl url-shortener spring-boot:run
```

Open http://localhost:8082.

## Standalone JAR

```bash
./scripts/run-standalone.sh
```

## PostgreSQL mode

```bash
brew install postgresql@16
brew services start postgresql@16
./scripts/setup-local-postgres.sh
./scripts/run-postgres.sh
```

## Optional Redis

```bash
brew install redis
brew services start redis
SHORT_URL_CACHE_ENABLED=true ./scripts/run-postgres.sh
```

H2 is for developer convenience and fast execution. PostgreSQL-specific compatibility is validated separately with Testcontainers in CI.
