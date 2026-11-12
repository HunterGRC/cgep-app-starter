package main
import rego.v1

test_s3_kms_pass if {
  inp := {"resource_changes": [
    {"type": "aws_s3_bucket", "name": "uploads", "address": "aws_s3_bucket.uploads"},
    {"type": "aws_s3_bucket_server_side_encryption_configuration", "name": "uploads", "change": {"after": {"sse": "aws:kms"}}}
  ]}
  not "SOC2 CC6.1 (GAP-01): aws_s3_bucket.uploads must use SSE-KMS (aws:kms)" in deny with input as inp
}

test_s3_kms_fail if {
  inp := {"resource_changes": [
    {"type": "aws_s3_bucket", "name": "uploads", "address": "aws_s3_bucket.uploads"}
  ]}
  "SOC2 CC6.1 (GAP-01): aws_s3_bucket.uploads must use SSE-KMS (aws:kms)" in deny with input as inp
}
