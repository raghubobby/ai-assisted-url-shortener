import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 1,
  iterations: 5,
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<500'],
  },
};

const base = __ENV.BASE_URL || 'http://localhost:8082';

export default function () {
  const id = `${__VU}-${__ITER}-${Date.now()}`;
  const create = http.post(`${base}/api/v1/urls`, JSON.stringify({
    url: `https://example.com/performance/${id}`,
  }), {
    headers: {
      'Content-Type': 'application/json',
      'Idempotency-Key': `k6-smoke-${id}`,
    },
  });

  check(create, { 'create is 201': (r) => r.status === 201 });
  if (create.status !== 201) return;

  const body = create.json();
  const redirect = http.get(`${base}/r/${body.code}`, { redirects: 0 });
  check(redirect, {
    'redirect is 302': (r) => r.status === 302,
    'redirect has Location': (r) => Boolean(r.headers.Location),
  });
  sleep(0.2);
}
