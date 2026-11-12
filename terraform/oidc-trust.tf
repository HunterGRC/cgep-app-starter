data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}
resource "aws_iam_role" "github_ci" {
  name = "${local.name_prefix}-ci-${local.suffix}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = data.aws_iam_openid_connect_provider.github.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = { "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com" }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:HunterGRC/cgep-app-starter:*",
            "repo:HunterGRC@*/cgep-app-starter@*:*"
          ]
        }
      }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "github_ci_admin" {
  role       = aws_iam_role.github_ci.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
output "github_ci_role_arn" {
  value = aws_iam_role.github_ci.arn
}
