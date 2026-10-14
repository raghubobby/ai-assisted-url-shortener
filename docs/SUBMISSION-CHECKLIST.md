# Submission Checklist

- [ ] `mvn test` is green locally
- [ ] `mvn verify` is green on a Docker-capable machine/CI
- [ ] browser UI opens at `http://localhost:8082`
- [ ] create generated link returns a seven-character code
- [ ] redirect returns `302`
- [ ] aggregate analytics render
- [ ] detailed analytics events render
- [ ] expiration/custom alias work
- [ ] deactivation returns later redirect as `410`
- [ ] README commands are current
- [ ] no secrets/API keys are committed
- [ ] `.gitignore` excludes build/IDE/local artifacts
- [ ] k6 scripts are present and thresholds documented
- [ ] three scenario documents are present and each maps decomposition → execution artifacts → validation evidence
- [ ] `docs/scenarios/README.md` evidence index matches the implemented code/tests
- [ ] AI engineering log includes accepted/edited/rejected/re-prompted reasoning
- [ ] final GitHub repository does not contain assignment PDFs or private credentials
