# Creating AWS Lambdas

After creating IAM policies on DynamoDB tables for AWS Lambdas, you are ready
to create your first AWS Lambda.

## Create custom module for AWS lambda

As in previous steps, create directory structure `modules/lambda/eu-central-1` and navigate there.

Copy [`labels.tf`](../labels.tf) to [`main.tf`](../modules/lambda/eu-central-1/main.tf) (inside `modules/lambda/eu-central-1`).

Copy [`context.tf`](../context.tf) to [`context.tf`](../modules/lambda/eu-central-1/context.tf) (inside `modules/lambda/eu-central-1`).

Replace properties `namespace`, `stage`, `environment`, `label_order` and `delimiter` with just:

```hcl
module "labels" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.25.0"

  name    = var.name
  context = var.context
}
```

Next, you need to know, how to describe AWS Lambda.

Copy the code from [this section](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#basic-example)
and append it to [`main.tf`](../modules/lambda/eu-central-1/main.tf) (inside `modules/lambda/eu-central-1`).

Delete `assume_role` and `iam_for_lambda` definitions, as you created
IAM roles in separate custom module.

Rename `"lambda"`, which is `archive` to `"lambda_source"` and `"test_lambda"` to just `"lambda"`.

Next, create [`variables.tf`](../modules/lambda/eu-central-1/variables.tf) (inside `modules/lambda/eu-central-1`) file
to accept `lambda_source_file` and `lambda_role_arn`:

```hcl
variable "lambda_source_file" {
  type = string
}

variable "lambda_role_arn" {
  type = string
}

variable "lambda_table_name" {
  type = string
}
```

To make possible to take `table_name` of DynamoDB table, open [`modules/dynamodb/eu-central-1/outputs.tf`](modules/dynamodb/eu-central-1/outputs.tf)
and change it accordingly:

```hcl
output "table_arn" {
  value = aws_dynamodb_table.this.arn
}

output "table_name" {
  value = aws_dynamodb_table.this.name
}
```

Use those variables in [`main.tf`](../modules/lambda/eu-central-1/main.tf) in order
to be able to create different lambdas in project root scope.

Final result should look like this:

```hcl
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
```

On the of this code you will see `payloads` in `locals` block.

This is the path for ZIP archive, where AWS Lambda's JS code will be packed.

You need to exclude this director in your [`.gitignore`](../.gitignore) file,
so that directory is not published on remote repository.

Just append `lambda-payloads/` to your [`.gitignore`](../.gitignore).

## Writing JS modules for AWS Lambda

As AWS Lambda performs some operations, those must
be described in imperative languages, such as `JavaScript`, `Python` or `C#`.

In current project you will use `JS`.

Start by creating `lambda-sources` directory.

First AWS Lambda to create is the `get-all-authors`.

In `lambda-sources` directory create [`get-all-authors.js`](../lambda-sources/get-all-authors/index.js) file and fill it with
[this contents](../lambda-sources/get-all-authors/index.js)

> **Note**
> You might want to specify other AWS SDK API version.
> For this, navigate to [this page](https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/Lambda.html) and
> copy API Version.

## Using AWS Lambda custom module

After that, start defining `get-all-authors-lambda` module in [`main.tf`](../main.tf) file.

[`main.tf`](../main.tf) is expected to look like this:

```hcl
module "courses" {
  source  = "./modules/dynamodb/eu-central-1"
  context = module.labels.context
  name    = "courses"
}

module "authors" {
  source  = "./modules/dynamodb/eu-central-1"
  context = module.labels.context
  name    = "authors"
}

module "get-all-authors-lambda" {
  source             = "./modules/lambda/eu-central-1"
  context            = module.labels.context
  lambda_role_arn    = module.get-all-authors-lambda-role.lambda_role_arn
  lambda_source_file = "${path.root}/lambda-sources/get-all-authors/index.js"
  name               = "get-all-authors-lambda"
  lambda_table_name  = module.authors.table_name
}
```

Finally, you need to do `terraform init` followed by:

```bash
terraform apply -var-file=dev.tfvars
```

Open AWS Console and search for Lambda.

Check the deployed JS code and envrionment variables in "Configuration" tab.

Try to run this lambda by creating a new test event, selecting it "Test" button dropdown and clicking it.

If everything is ok, you can proceed with creating next AWS Lambdas.

> **Warning**
> In lambda scripts in this repository, `update-course-lambda` uses `PutItem` operation.
>
> You need to change action from `UpdateItem` to `PutItem` for `update-course-lambda-role` IAM role.
> In this repo it is located in [`iam-lambda-roles.tf`](../iam-lambda-roles.tf) file.


List of Lambdas you should create is the next:

- `get-all-courses-lambda`
- `get-course-lambda`
- `save-course-lambda`
- `update-course-lambda`
- `delete-course-lambda`

To compare your result with expected, check [`main.tf`](../main.tf) file and `lambda-sources` directory.

After that done, run `terraform init`, followed by:

```bash
terraform apply -var-file=dev.tfvars
```

To configure test events, use [this documentation](https://docs.google.com/document/d/12_xdimIO-jxPWBBunhgY3vgQKBUqBjgcuHQyWl3bTTo/edit#).
Search for the name of lambda, for example `save-course` and find JSON with example data.

