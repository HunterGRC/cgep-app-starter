package main
import rego.v1

has_wildcard_action(rc) if {
  contains(rc.change.after.policy, "dynamodb:*")
}
has_wildcard_action(rc) if {
  contains(rc.change.after.policy, "s3:*")
}
has_wildcard_action(rc) if {
  some res in input.configuration.root_module.resources
  res.address == rc.address
  walk(res.expressions, [_, val])
  val in ["dynamodb:*", "s3:*"]
}

# METADATA
# title: SOC 2 CC6.3 - IAM Least Privilege
# custom:
#   framework: soc2
#   controls: ["CC6.3"]
#   severity: high
#   remediation: Replace dynamodb:* and s3:* with scoped actions
deny contains msg if {
  some rc in input.resource_changes
  rc.type == "aws_iam_role_policy"
  has_wildcard_action(rc)
  msg := sprintf("SOC2 CC6.3 (GAP-07): %s grants wildcard permissions", [rc.address])
}
