# Acme Health Patient Intake API — GRC Engineering Capstone Writeup

## 1. Executive Summary & Framework Selection
This capstone hardens the Acme Health Patient Intake API to meet **SOC 2 Type II** Trust Services Criteria (`CC6.1`, `CC6.2`, `CC6.3`, `CC6.6`, `CC6.7`, `CC7.2`, and `A1.2`). All eight architectural gaps (`GAP-01` through `GAP-08`) are remediated in Terraform, enforced pre-merge via Open Policy Agent (Conftest), and attested via keyless Cosign signatures stored in an S3 Object Lock (`GOVERNANCE`) Evidence Vault.

## 2. Remediation of Starter Gaps (GAP-01 to GAP-08)
| Gap | SOC 2 Control | Remediation Implemented | Rego Policy Gate |
| :--- | :--- | :--- | :--- |
| **GAP-01** | `CC6.1` | S3 `uploads` bucket encrypted with customer-managed KMS key (`aws_kms_key.workload`) | `policies/s3_encryption.rego` |
| **GAP-02** | `CC6.1` | DynamoDB `intake` table encrypted with CMK KMS + Point-in-Time Recovery enabled | `policies/dynamodb_encryption.rego` |
| **GAP-03** | `CC6.7` | S3 bucket policy denies requests where `aws:SecureTransport` is `false` | Infrastructure baseline |
| **GAP-04** | `A1.2` | S3 versioning enabled on `uploads` bucket | `policies/s3_versioning.rego` |
| **GAP-05** | `CC6.6` | Lambda placed inside private VPC subnets with S3/DynamoDB Gateway Endpoints | `policies/lambda_vpc.rego` |
| **GAP-06** | `A1.2` | KMS-encrypted SQS Dead Letter Queue (`lambda_dlq`) attached to Lambda | Infrastructure baseline |
| **GAP-07** | `CC6.3` | Replaced `dynamodb:*` and `s3:*` with scoped `PutItem`/`GetItem`/`PutObject`/`GetObject` | `policies/iam_least_privilege.rego` |
| **GAP-08** | `CC7.2` | API Gateway v2 stage access logging configured | **GAP-08** | `CC7.2` | APIetention) | Infrastructure baseline |

## 3. Continuous Assurance Pipeline & Chain of Custody
The `.github/workflows/grc-gate.yml` workflow executes five ordered stages:
1. **Plan:** Generates the deterministic Terraform plan (`plan.json`).
2. **Policy check:** Evaluates `plan.json` against the 5 SOC 2 Rego policies (`conftest test`). Pull requests violating any policy fail closed (demonstrated in PR #2).
3. **Apply:** Executes `terraform apply` on merges to `main` via GitHub OIDC (`sts:AssumeRoleWithWebIdentity`).
4. **Sign:** Packages `plan.json`, Conftest output, and commit metadata into `evidence-<RUN_ID>.tar.gz`, generates a `.sha256` digest, and signs keyless via Sigstore Fulcio/Rekor (`cosign sign-blob`).
5. **Upload:** Writes the archive, `.sha256`, and `.sig.bundle` to `s3://<EVIDENCE_VAULT>/runs/<RUN_ID>/` under S3 Object Lock `GOVERNANCE` retention.

## 4. Auditor Verification
Auditors can independently verify any run using:
```bash
EVIDENCE_VAULT="<vault-bucket-name>" bash scripts/verify-evidence.sh "<RUN_ID>"


This confirms S3 Object Lock (GOVERNANCE), SHA-256 digest, and Sigstore OIDC identity, outputting CHAIN INTACT.

## 5. Design Trade-Offs
- **Gateway Endpoints vs. NAT Gateway:** Used S3/DynamoDB Gateway Endpoints to keep private subnet traffic on the AWS backbone with zero hourly NAT cost.
- **Shared KMS CMK:** Used a single rotating CMK across S3, DynamoDB, and SQS to simplify key policies and lower KMS cost.
- **Object Lock GOVERNANCE Mode:** Enforces immutability against standard deletion while allowing privileged cleanup after grading.

## 6. What I Didn't Get To
- **WAF & Rate Limiting:** Adding AWS WAFv2 on API Gateway for layer-7 throttling.
- **Automated Drift Detection:** Scheduled nightly Terraform drift checks with Slack alerts.

## 5. Design Trade-Offs
- **Gateway Endpoints vs. NAT Gateway:** Used S3/DynamoDB Gateway Endpoints to keep private subnet traffic on the AWS backbone with zero hourly NAT cost.
- **Shared KMS CMK:** Used a single rotating CMK across S3, DynamoDB, and SQS to simplify key policies and lower KMS cost.
- **Object Lock GOVERNANCE Mode:** Enforces immutability against standard deletion while allowing privileged cleanup after grading.

## 6. What I Didn't Get To
- **WAF & Rate Limiting:** Adding AWS WAFv2 on API Gateway for layer-7 throttling.
- **Automated Drift Detection:** Scheduled nightly Terraform drift checks with Slack alerts.

## 7. Bidirectional Traceability Matrix

### 7.1 Control-to-Artifact Mapping (Control -> Code, Policy & Evidence)
| SOC 2 Control | Terraform Resource | OPA Rego Policy & Test | OSCAL Requirement UUID |
| :--- | :--- | :--- | :--- |
| CC6.1 | aws_kms_key.workload, aws_s3_bucket_server_side_encryption_configuration.uploads, aws_dynamodb_table.intake | s3_encryption.rego, dynamodb_encryption.rego | 33333333-4444-4555-8666-777777777701 |
| CC6.3 | aws_iam_role_policy.lambda_policy | iam_least_privilege.rego | 33333333-4444-4555-8666-777777777702 |
| CC6.6 | aws_lambda_function.intake (vpc_config), aws_vpc_endpoint.s3, aws_vpc_endpoint.dynamodb | lambda_vpc.rego | 33333333-4444-4555-8666-777777777703 |
| CC6.7 | aws_s3_bucket_policy.uploads_tls | Infrastructure baseline | 33333333-4444-4555-8666-777777777704 |
| CC7.2 | aws_cloudtrail.main, aws_apigatewayv2_stage.default | Infrastructure baseline | 33333333-4444-4555-8666-777777777705 |
| A1.2 | aws_s3_bucket_versioning.uploads, aws_sqs_queue.lambda_dlq, aws_s3_bucket_object_lock_configuration.evidence | A1.2 | aws_s3_bucket_versioning.uploads, aws_sqs_queue.lambda_dlq, 2 Ar| A1.2 | aws_s3_bucket_versioning.uploads, aws_sqs_queue.lambda_dlq, aws_s3_bucketPurpose | Mapped SOC 2 Controls |
| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| :| : CloudTrail | CC7.2, A1.2 |
| policies/*.rego | Pre-merge Conftest policy gate & unit tests | CC6.1, CC6.2, CC6.3,| policies/*.rego | Pre-merge Conftest policy gate & unit tests | CC6.1, CC6.2, CC6.3,| policies/*.rego | Pre-merge Conftest policy gate & unit tests | CCtient-intake.json | Machine-readable OSCAL 1.1.2 component definition | CC6.1, CC6.3, CC6.6, CC6.7, CC7.2, A1.2 |
