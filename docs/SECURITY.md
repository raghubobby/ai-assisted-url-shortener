# Security

## Implemented controls

### Destination URL policy

- only `http` and `https`
- no embedded username/password credentials
- reject localhost/loopback literals
- reject common private/link-local literal address ranges
- normalize before persistence
- maximum input length

### Alias policy

Custom aliases use a strict allow-list:

```text
[A-Za-z0-9_-]{4,32}
```

### Analytics privacy

The application stores:

- referrer **host**, not full referrer URL
- coarse browser family, not the full User-Agent string

This reduces unnecessary path/query leakage and fingerprintability for an assessment prototype.

### AI-assisted engineering safety

- no secret is required for the default demo
- AI outputs are proposals, not authorization
- deterministic compiler/tests/security/performance evidence decides whether engineering claims are supported
- human engineering ownership is explicit

## Known limitation: SSRF/DNS rebinding

Literal local/private targets are rejected, but this prototype does not claim complete production SSRF defense against DNS rebinding or a hostname that resolves to a private address after validation.

A production hardening path would resolve and validate addresses at connect time (or use an egress proxy/network policy), block private/link-local ranges for every resolved address, define redirect-following policy, and defend against DNS rebinding/time-of-check/time-of-use issues.
