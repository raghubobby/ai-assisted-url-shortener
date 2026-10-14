# API Reference

Base path for management APIs: `/api/v1/urls`.

## Create a short URL

```http
POST /api/v1/urls
Content-Type: application/json
Idempotency-Key: optional-client-key
```

```json
{
  "url": "https://example.com/reports/2026",
  "customAlias": "annual-report",
  "expiresAt": "2026-12-31T23:59:59Z"
}
```

`customAlias` and `expiresAt` are optional.

Generated links use a seven-character Base62 code by default.

### Response

`201 Created`

```json
{
  "code": "annual-report",
  "shortUrl": "http://localhost:8082/r/annual-report",
  "destinationUrl": "https://example.com/reports/2026",
  "createdAt": "2026-10-13T21:00:00Z",
  "expiresAt": "2026-12-31T23:59:59Z",
  "active": true,
  "status": "ACTIVE"
}
```

## Redirect

```http
GET /r/{code}
```

Successful response:

```http
HTTP/1.1 302 Found
Location: https://example.com/reports/2026
X-Redirect-Cache: HIT
X-App-Instance: app-1
```

## Get metadata

```http
GET /api/v1/urls/{code}
```

## Aggregate analytics

```http
GET /api/v1/urls/{code}/analytics
```

Example:

```json
{
  "code": "annual-report",
  "totalClicks": 14,
  "lastClickedAt": "2026-10-13T21:15:00Z",
  "lastSevenDays": [
    {"day":"2026-10-07","clicks":0},
    {"day":"2026-10-08","clicks":2}
  ],
  "topReferrers": [
    {"value":"google.com","clicks":7}
  ],
  "browserFamilies": [
    {"value":"Chrome","clicks":9}
  ]
}
```

## Detailed analytics

```http
GET /api/v1/urls/{code}/analytics/events?limit=25
```

`limit` is bounded to 1–100.

Example:

```json
{
  "code":"annual-report",
  "totalClicks":14,
  "events":[
    {
      "occurredAt":"2026-10-13T21:15:00Z",
      "referrerHost":"google.com",
      "userAgentFamily":"Chrome"
    }
  ]
}
```

## Deactivate

```http
DELETE /api/v1/urls/{code}
```

Returns `204 No Content`. This is a soft delete; the mapping and analytics remain persisted.

## Structured errors

Errors return a stable code plus message/field details. Common mappings:

| Condition | HTTP | Code |
|---|---:|---|
| invalid request/unsafe URL | 400 | `INVALID_REQUEST` |
| unknown short code | 404 | `SHORT_URL_NOT_FOUND` |
| expired/deactivated | 410 | `SHORT_URL_INACTIVE` |
| custom alias collision | 409 | `CUSTOM_ALIAS_TAKEN` |
| idempotency key reused with a different request | 409 | `IDEMPOTENCY_KEY_REUSED` |


### Lifecycle status

`status` is one of `ACTIVE`, `EXPIRED`, or `DEACTIVATED`. The legacy `active` boolean is retained for simple clients.
