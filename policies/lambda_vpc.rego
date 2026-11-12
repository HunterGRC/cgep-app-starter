package main
import rego.v1

has_vpc(rc) if {
  count(rc.change.after.vpc_config) > 0
}

# METADATA
# title: SOC 2 CC6.6 - Lambda VPC Boundary Protection
# custom:
#   framework: soc2
#   controls: ["CC6.6"]
#   severity: high
#   remediation: Configure vpc_config on aws_lambda_function
deny contains msg if {
  some rc in input.resource_changes
  rc.type == "aws_lambda_function"
  not has_vpc(rc)
  msg := sprintf("SOC2 CC6.6 (GAP-05): %s must be deployed inside a VPC", [rc.address])
}
