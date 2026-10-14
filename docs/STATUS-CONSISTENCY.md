# Link status consistency

The browser's **Recent links** section is local demo history, not authoritative application state.
It previously persisted the `active` value returned at creation time, which could become stale after a link expired.

The UI now:

1. derives expiry immediately from `expiresAt`,
2. refreshes recent-link metadata from `GET /api/v1/urls/{code}` on page load,
3. refreshes the local history entry whenever analytics/details are opened, and
4. displays the backend lifecycle status explicitly as `Active`, `Expired`, or `Deactivated`.

The API retains `active` for simple clients and now also returns:

```json
{
  "active": false,
  "status": "EXPIRED"
}
```

PostgreSQL/H2 state remains authoritative; browser `localStorage` is only a convenience history list.
