# Push to GitHub

From the repository root:

```bash
git init
git add .
git commit -m "Build AI-assisted URL shortener assessment"
git branch -M main
git remote add origin https://github.com/<your-user>/<your-repo>.git
git push -u origin main
```

Recommended repository description:

> Engineer-led AI-assisted URL shortener built with Java 21, Spring Boot, PostgreSQL, Redis, H2, NGINX, Testcontainers and k6.

Recommended topics:

```text
java spring-boot url-shortener postgresql redis h2 testcontainers k6 ai-assisted-engineering system-design
```

Before pushing:

```bash
./scripts/quality-gates.sh
```

On a Docker-capable environment/CI:

```bash
mvn clean verify
```
