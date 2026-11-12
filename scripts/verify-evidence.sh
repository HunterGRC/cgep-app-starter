#!/usr/bin/env bash
set -euo pipefail
RUN_ID="${1:?Usage: verify-evidence.sh <RUN_ID>}"
VAULT="${EVIDENCE_VAULT:?Set EVIDENCE_VAULT}"
WORK="/tmp/verify-${RUN_ID}"
mkdir -p "$WORK"
PREFIX="runs/${RUN_ID}/evidence-${RUN_ID}.tar.gz"
aws s3 cp "s3://${VAULT}/${PREFIX}" "$WORK/evidence-${RUN_ID}.tar.gz"
aws s3 cp "s3://${VAULT}/${PREFIX}.sha256" "$WORK/evidence-${RUN_ID}.tar.gz.sha256"
aws s3 cp "s3://${VAULT}/${PREFIX}.sig.bundle" "$WORK/evidence-${RUN_ID}.tar.gz.sig.bundle"
LOCK=$(aws s3api get-object-retention --bucket "$VAULT" --key "$PREFIX" --query 'Retention.Mode' --output text)
echo "Object Lock Mode: $LOCK"
[[ "$LOCK" == "GOVERNANCE" || "$LOCK" == "COMPLIANCE" ]]
(cd "$WORK" && shasum -a 256 -c "evidence-${RUN_ID}.tar.gz.sha256")
cosign verify-blob "$WORK/evidence-${RUN_ID}.tar.gz" \
  --bundle "$WORK/evidence-${RUN_ID}.tar.gz.sig.bundle" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  --certificate-identity-regexp="https://github.com/HunterGRC/cgep-app-starter/.*"
echo "CHAIN INTACT"
