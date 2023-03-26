module "labels" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.25.0"

  name    = var.name
  context = var.context
}

resource "aws_iam_role_policy" "iam_lambda_policy" {
  name   = module.labels.id
  role   = aws_iam_role.iam_lambda_role.id
  policy = var.policy
}

resource "aws_iam_role" "iam_lambda_role" {
  name = module.labels.id

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
