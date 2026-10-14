import http from 'k6/http';
import { check } from 'k6';

const base = __ENV.BASE_URL || 'http://localhost:8082';
const code = __ENV.SHORT_CODE;
if (!code) throw new Error('SHORT_CODE is required. Create a link first and export SHORT_CODE=<code>.');

export const options = {
  stages: [
    { duration: '10s', target: 20 },
    { duration: '30s', target: 50 },
    { duration: '10s', target: 0 },
  ],
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<100', 'p(99)<200'],
  },
};

export default function () {
  const r = http.get(`${base}/r/${code}`, { redirects: 0 });
  check(r, {
    'redirect is 302': (response) => response.status === 302,
    'location exists': (response) => Boolean(response.headers.Location),
  });
}
