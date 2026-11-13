# Acme Health Patient Intake API — CGE-P Capstone (SOC 2 Type II)

Hardened serverless patient intake API enforcing **SOC 2 Type II** controls (`CC6.1`, `CC6.2`, `CC6.3`, `CC6.6`, `CC6.7`, `CC7.2`, `A1.2`) with Terraform, OPA/Conftest, Cosign keyless signing, S3 Object Lock, and OSCAL 1.1.2.

## Grader Verification Instructions

1. **Run OPA Rego Policy Unit Tests (5 policies, 10 tests):**
    opa test ./policies -v

2. **Validate OSCAL 1.1.2 Profile & Component Definition:**
    trestle validate -f oscal/profiles/soc2-minimum.json
    trestle validate -f oscal/components/patient-intake.json

3. **Verify Signed Evidence Bundle in S3 Vault:**
    EVIDENCE_VAULT="acme-health-intake-evidence-6b08c38c" bash scripts/verify-evidence.sh 43334898425

4. **PR History & Architecture Writeup:**
- Green PR (Merged): PR #1 (`feat/soc2-grc-baseline`)
- Red PR (Blocked by Gate): PR #2 (`test/reintroduce-gap-07`)
- Full Writeup: See `WRITEUP.md`
