#!/usr/bin/env bash
set -euo pipefail
RUN_ID="${1:-$(date -u +%Y%m%dT%H%M%SZ)}"
OUT_DIR="${2:-/tmp/evidence-${RUN_ID}}"
mkdir -p "$OUT_DIR"
cp terraform/plan.json "$OUT_DIR/plan.json"
conftest test terraform/plan.json -p policies --output json > "$OUT_DIR/policy-results.json" || true
jq -n \
  --arg run_id "$RUN_ID" \
  --arg sha "${GITHUB_SHA:-$(git rev-parse HEAD)}" \
  --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '{run_id: $run_id, commit: $sha, timestamp: $ts, framework: "soc2"}' \
  > "$OUT_DIR/metadata.json"
tar -czf "evidence-${RUN_ID}.tar.gz" -C "$OUT_DIR" .
shasum -a 256 "evidence-${RUN_ID}.tar.gz" > "evidence-${RUN_ID}.tar.gz.sha256"
