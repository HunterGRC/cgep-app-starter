# SOC 2 Type II Continuous Assurance & GRC Engineering Pipeline

Welcome to my **CGE-P** capstone repo. I hardened a serverless AWS Patient Intake API (8 gaps) with **SOC 2 Type II** controls (`CC6.1`-`A1.2`).

> **Note:** Live AWS resources are torn down ($0 cost) and CI/CD is manual-only (`workflow_dispatch`).

## What This Repo Demonstrates
- **Hardened AWS IaC (`terraform/`):** Rotating KMS CMK, private VPC + Gateway Endpoints, least-privilege IAM, TLS, CloudTrail, SQS DLQ, and S3 Object Lock (`GOVERNANCE`) Vault.
- **Policy-as-Code (`policies/`):** 5 OPA/Rego policies with 10 unit tests enforced via Conftest.
- **Keyless CI/CD (`.github/workflows/grc-gate.yml`):** 5-stage pipeline using GitHub OIDC, keyless Sigstore Cosign signing, and SHA-256 digests.
- **OSCAL 1.1.2 (`oscal/`):** Profile and component definition validated with Compliance Trestle.

## Key Artifacts
- **Green PR:** [PR #1](https://github.com/HunterGRC/cgep-app-starter/pull/1) | **Red PR (Blocked):** [PR #2](https://github.com/HunterGRC/cgep-app-starter/pull/2)
- **Full Writeup & Traceability Matrix:** See [`WRITEUP.md`](WRITEUP.md)

## Local Verification (No AWS Required)
Run `opa test ./policies -v` to execute all 5 Rego policies and 10 unit tests.

## Tech Stack
`AWS` | `Terraform` | `OPA/Rego` | `Conftest` | `GitHub Actions` | `OIDC` | `Sigstore Cosign` | `S3 Object Lock` | `OSCAL 1.1.2`
