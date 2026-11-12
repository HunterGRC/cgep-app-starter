package main
import rego.v1

test_ddb_kms_pass if {
  inp := {"resource_changes": [{
    "type": "aws_dynamodb_table",
    "address": "aws_dynamodb_table.intake",
    "change": {"after": {"server_side_encryption": [{"enabled": true}]}}
  }]}
  not "SOC2 CC6.1 (GAP-02): aws_dynamodb_table.intake must enable CMK server_side_encryption" in deny with input as inp
}

test_ddb_kms_fail if {
  inp := {"resource_changes": [{
    "type": "aws_dynamodb_table",
    "address": "aws_dynamodb_table.intake",
    "change": {"after": {"server_side_encryption": []}}
  }]}
  "SOC2 CC6.1 (GAP-02): aws_dynamodb_table.intake must enable CMK server_side_encryption" in deny with input as inp
}
