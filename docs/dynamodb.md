# Creating DynamoDB tables

Finally, after setting up the project, the first resource in your IaC can be described.

Here, DynamoDB will be created with custom Terraform module.

This means, that you create a module in some directory, and then you import this module with `source`
property in other module, specifically in this scenario, we will import it in [`main.tf`](../main.tf) file.

## Creating DynamoDB custom module

> **Note**
> This section assumes, you have `AWS_DEFAULT_REGION` set up to `eu-central-1`.
> If this is not the case, replace this region with yours.

Start by creating `modules/dynamodb/eu-central-1` directory:

```bash
mkdir -p modules/dynamodb/eu-central-1
```

Proceed into this directory with:

```bash
cd modules/dynamodb/eu-central-1
```

Next, you have to know, how to describe DynamoDB table in Terraform.
For that, proceed to [this page](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table#global-tables)
, copy the code from this section to [`main.tf`](../modules/dynamodb/eu-central-1/main.tf) (inside `modules/dynamodb/eu-central-1`).

Next, update the contents of file:

```hcl
resource "aws_dynamodb_table" "this" {
  name         = "example"
  hash_key     = "Id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "Id"
    type = "S"
  }
}
```

### Creating `labels` module for custom module

In [Terraform Null Label](./terraform-null-label.md) step we created `labels` module for entire project.

Now we're going to do the same, but for our DynamoDB custom module.

> *Note*
> The next command assumes you are in `modules/dynamodb/eu-central-1` directory.

Copy [`context.tf`](../context.tf) file from project root directory to `modules/dynamodb/eu-central-1` directory with command:

```bash
cp ../../../context.tf ./
```

Next, display contents of [`labels.tf`](../labels.tf) file from project root directory
and prepend them to [`main.tf`](../modules/dynamodb/eu-central-1/main.tf) (inside `modules/dynamodb/eu-central-1`)
with commands:

```bash
cat ../../../labels.tf | cat - main.tf > main_new.tf
mv main_new.tf main.tf
```

Resulting file contents should look like this:

```hcl
module "base_labels" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.25.0"

  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  label_order = var.label_order
  delimiter   = var.delimiter
  # name       = "bastion"
  # attributes = ["public"]
  # delimiter  = "-"

  # tags = {
  #   "BusinessUnit" = "XYZ",
  #   "Snapshot"     = "true"
  # }
}
resource "aws_dynamodb_table" "this" {
  name         = "example"
  hash_key     = "Id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "Id"
    type = "S"
  }
}
```

> *Note*
> If you named your `labels` module differently, do not forget to change its name here.

Next, you need to modify this code, so it uses `context` variable, and `aws_dynamodb_table` has name from `labels` module.

This results in:

```hcl
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
```

## Using DynamoDB custom module

Out custom module is ready to be used in [`main.tf`](../main.tf) file.

Navigate to project root directory, and create `main.tf` file:


```hcl
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
```

## Init and apply

You need to run `terraform init` again, as the new `labels` module is created in DynamoDB custom module.

Finally, you are ready to `apply` your IaC, just run:

```bash
terraform apply -var-file=dev.tfvars
```

Check what `terraform` outputs for you. If everything is ok, type `yes`.

Changes to DynamoDB infrastructure will be visible in your AWS console.

