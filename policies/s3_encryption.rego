package main
import rego.v1

has_uploads_kms if {
  some rc in input.resource_changes
  rc.type == "aws_s3_bucket_server_side_encryption_configuration"
  rc.name == "uploads"
  walk(rc.change.after, [_, "aws:kms"])
}

# METADATA
# title: SOC 2 CC6.1 - S3 KMS Encryption
# custom:
#   framework: soc2
#   controls: ["CC6.1"]
#   severity: high
#   remediation: Configure aws_s3_bucket_server_side_encryption_configuration with aws:kms
deny contains msg if {
  some rc in input.resource_changes
  rc.type == "aws_s3_bucket"
  rc.name == "uploads"
  not has_uploads_kms
  msg := sprintf("SOC2 CC6.1 (GAP-01): %s must use SSE-KMS (aws:kms)", [rc.address])
}
