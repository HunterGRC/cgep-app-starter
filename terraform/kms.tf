resource "aws_kms_key" "workload" {
  description             = "Acme Health CMK for PHI stores and evidence vault"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "workload" {
  name          = "alias/${local.name_prefix}-${local.suffix}"
  target_key_id = aws_kms_key.workload.key_id
}

output "kms_key_arn" {
  value = aws_kms_key.workload.arn
}
