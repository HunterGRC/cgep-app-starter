package main
import rego.v1

test_lambda_vpc_pass if {
  inp := {"resource_changes": [{
    "type": "aws_lambda_function",
    "address": "aws_lambda_function.intake",
    "change": {"after": {"vpc_config": [{"subnet_ids": ["subnet-1"]}]}}
  }]}
  not "SOC2 CC6.6 (GAP-05): aws_lambda_function.intake must be deployed inside a VPC" in deny with input as inp
}

test_lambda_vpc_fail if {
  inp := {"resource_changes": [{
    "type": "aws_lambda_function",
    "address": "aws_lambda_function.intake",
    "change": {"after": {"vpc_config": []}}
  }]}
  "SOC2 CC6.6 (GAP-05): aws_lambda_function.intake must be deployed inside a VPC" in deny with input as inp
}
