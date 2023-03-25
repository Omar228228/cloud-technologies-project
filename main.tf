module "courses" {
  source  = "./modules/dynamodb/eu-central-1"
  context = module.base_labels.context
  name    = "courses"
}

module "authors" {
  source  = "./modules/dynamodb/eu-central-1"
  context = module.base_labels.context
  name    = "authors"
}
