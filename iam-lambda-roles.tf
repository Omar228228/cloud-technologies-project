module "get-all-authors-lambda-role" {
  source  = "./modules/iam/eu-central-1"
  context = module.base_labels.context
  name    = "get-all-authors-lambda-role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:Scan",
        ],
        Resource = module.authors.table_arn
      }
    ]
  })
}

module "get-all-courses-lambda-role" {
  source  = "./modules/iam/eu-central-1"
  context = module.base_labels.context
  name    = "get-all-courses-lambda-role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:Scan",
        ],
        Resource = module.courses.table_arn
      }
    ]
  })
}

module "get-course-lambda-role" {
  source  = "./modules/iam/eu-central-1"
  context = module.base_labels.context
  name    = "get-course-lambda-role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
        ],
        Resource = module.courses.table_arn
      }
    ]
  })
}

module "save-course-lambda-role" {
  source  = "./modules/iam/eu-central-1"
  context = module.base_labels.context
  name    = "save-course-lambda-role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
        ],
        Resource = module.courses.table_arn
      }
    ]
  })
}

module "update-course-lambda-role" {
  source  = "./modules/iam/eu-central-1"
  context = module.base_labels.context
  name    = "update-course-lambda-role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
        ],
        Resource = module.courses.table_arn
      }
    ]
  })
}

module "delete-course-lambda-role" {
  source  = "./modules/iam/eu-central-1"
  context = module.base_labels.context
  name    = "delete-course-lambda-role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:DeleteItem",
        ],
        Resource = module.courses.table_arn
      }
    ]
  })
}

