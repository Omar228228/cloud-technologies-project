module "labels" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.25.0"

  context = var.context
  name    = var.name
}

resource "aws_dynamodb_table" "this" {
  name         = module.labels.id
  hash_key     = "Id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "Id"
    type = "S"
  }
}

