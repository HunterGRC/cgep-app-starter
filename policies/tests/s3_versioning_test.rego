package main
import rego.v1

test_s3_ver_pass if {
  inp := {"resource_changes": [
    {"type": "aws_s3_bucket", "name": "uploads", "address": "aws_s3_bucket.uploads"},
    {"type": "aws_s3_bucket_versioning", "name": "uploads", "change": {"after": {"status": "Enabled"}}}
  ]}
  not "SOC2 A1.2 (GAP-04): aws_s3_bucket.uploads must enable bucket versioning" in deny with input as inp
}

test_s3_ver_fail if {
  inp := {"resource_changes": [
    {"type": "aws_s3_bucket", "name": "uploads", "address": "aws_s3_bucket.uploads"}
  ]}
  "SOC2 A1.2 (GAP-04): aws_s3_bucket.uploads must enable bucket versioning" in deny with input as inp
}
