package main
import rego.v1

test_iam_lp_pass if {
  inp := {"resource_changes": [{
    "type": "aws_iam_role_policy",
    "address": "aws_iam_role_policy.lambda_inline",
    "change": {"after": {"policy": "{\"Action\":[\"dynamodb:PutItem\"]}"}}
  }]}
  not "SOC2 CC6.3 (GAP-07): aws_iam_role_policy.lambda_inline grants wildcard permissions" in deny with input as inp
}

test_iam_lp_fail if {
  inp := {"resource_changes": [{
    "type": "aws_iam_role_policy",
    "address": "aws_iam_role_policy.lambda_inline",
    "change": {"after": {"policy": "{\"Action\":\"dynamodb:*\"}"}}
  }]}
  "SOC2 CC6.3 (GAP-07): aws_iam_role_policy.lambda_inline grants wildcard permissions" in deny with input as inp
}
