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

module "get-all-authors-lambda" {
  source             = "./modules/lambda/eu-central-1"
  context            = module.base_labels.context
  lambda_role_arn    = module.get-all-authors-lambda-role.lambda_role_arn
  lambda_source_file = "${path.root}/lambda-sources/get-all-authors/index.js"
  name               = "get-all-authors-lambda"
  lambda_table_name  = module.authors.table_name
}

module "get-all-courses-lambda" {
  source             = "./modules/lambda/eu-central-1"
  context            = module.base_labels.context
  lambda_role_arn    = module.get-all-courses-lambda-role.lambda_role_arn
  lambda_source_file = "${path.root}/lambda-sources/get-all-courses/index.js"
  name               = "get-all-courses-lambda"
  lambda_table_name  = module.courses.table_name
}

module "get-course-lambda" {
  source             = "./modules/lambda/eu-central-1"
  context            = module.base_labels.context
  lambda_role_arn    = module.get-course-lambda-role.lambda_role_arn
  lambda_source_file = "${path.root}/lambda-sources/get-course/index.js"
  name               = "get-course-lambda"
  lambda_table_name  = module.courses.table_name
}

module "save-course-lambda" {
  source             = "./modules/lambda/eu-central-1"
  context            = module.base_labels.context
  lambda_role_arn    = module.save-course-lambda-role.lambda_role_arn
  lambda_source_file = "${path.root}/lambda-sources/save-course/index.js"
  name               = "save-course-lambda"
  lambda_table_name  = module.courses.table_name
}

module "update-course-lambda" {
  source             = "./modules/lambda/eu-central-1"
  context            = module.base_labels.context
  lambda_role_arn    = module.update-course-lambda-role.lambda_role_arn
  lambda_source_file = "${path.root}/lambda-sources/update-course/index.js"
  name               = "update-course-lambda"
  lambda_table_name  = module.courses.table_name
}

module "delete-course-lambda" {
  source             = "./modules/lambda/eu-central-1"
  context            = module.base_labels.context
  lambda_role_arn    = module.delete-course-lambda-role.lambda_role_arn
  lambda_source_file = "${path.root}/lambda-sources/delete-course/index.js"
  name               = "delete-course-lambda"
  lambda_table_name  = module.courses.table_name
}

