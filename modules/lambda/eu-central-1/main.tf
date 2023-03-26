locals {
  payload = "${path.root}/lambda-payloads/${module.labels.name}_payload.zip"
}

data "aws_region" "current" {}

module "labels" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.25.0"

  name    = var.name
  context = var.context
}

data "archive_file" "lambda_source" {
  type        = "zip"
  source_file = var.lambda_source_file
  output_path = local.payload
}

resource "aws_lambda_function" "lambda" {
  filename      = local.payload
  function_name = module.labels.id
  role          = var.lambda_role_arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.lambda_source.output_base64sha256

  runtime = "nodejs16.x"

  environment {
    variables = {
      aws_region = data.aws_region.current.name
      table_name = var.lambda_table_name
    }
  }
}

