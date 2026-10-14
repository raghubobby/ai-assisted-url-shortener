import http from 'k6/http';
import { check } from 'k6';

const base = __ENV.BASE_URL || 'http://localhost:8082';

export const options = {
  scenarios: {
    creates: {
      executor: 'constant-arrival-rate',
      rate: 20,
      timeUnit: '1s',
      duration: '30s',
      preAllocatedVUs: 10,
      maxVUs: 50,
    },
  },
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<250', 'p(99)<500'],
  },
};

export default function () {
  const id = `${__VU}-${__ITER}-${Date.now()}-${Math.random()}`;
  const r = http.post(`${base}/api/v1/urls`, JSON.stringify({
    url: `https://example.com/load/${encodeURIComponent(id)}`,
  }), {
    headers: {
      'Content-Type': 'application/json',
      'Idempotency-Key': `k6-create-${id}`,
    },
  });
  check(r, { 'create is 201': (response) => response.status === 201 });
}
