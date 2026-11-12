package main
import rego.v1

has_uploads_versioning if {
  some rc in input.resource_changes
  rc.type == "aws_s3_bucket_versioning"
  rc.name == "uploads"
  walk(rc.change.after, [_, "Enabled"])
}

# METADATA
# title: SOC 2 A1.2 - S3 Versioning Enabled
# custom:
#   framework: soc2
#   controls: ["A1.2"]
#   severity: medium
#   remediation: Enable aws_s3_bucket_versioning on the uploads bucket
deny contains msg if {
  some rc in input.resource_changes
  rc.type == "aws_s3_bucket"
  rc.name == "uploads"
  not has_uploads_versioning
  msg := sprintf("SOC2 A1.2 (GAP-04): %s must enable bucket versioning", [rc.address])
}
