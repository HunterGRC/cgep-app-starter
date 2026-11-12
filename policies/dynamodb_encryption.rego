package main
import rego.v1

has_ddb_kms(rc) if {
  some sse in rc.change.after.server_side_encryption
  sse.enabled == true
}

# METADATA
# title: SOC 2 CC6.1 - DynamoDB CMK Encryption
# custom:
#   framework: soc2
#   controls: ["CC6.1"]
#   severity: high
#   remediation: Enable server_side_encryption with CMK on aws_dynamodb_table
deny contains msg if {
  some rc in input.resource_changes
  rc.type == "aws_dynamodb_table"
  not has_ddb_kms(rc)
  msg := sprintf("SOC2 CC6.1 (GAP-02): %s must enable CMK server_side_encryption", [rc.address])
}
