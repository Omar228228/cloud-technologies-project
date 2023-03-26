# IAM roles on DynamoDB tables

As in next steps you will create AWS Lambdas, you will need to apply
strict roles for each Lambda.

For example, lambda, which gets all `authors`, should not write to this table.

## Adding table ARN to outputs

IAM roles on DynamoDB tables will need their ARN.

For this, you need access to each table ARN in [`main.tf`](../main.tf) file.

Navigate to `modules/dynamodb/eu-central-1` and create [`outputs.tf`](../modules/dynamodb/outputs.tf) file.

Obtain the ARN of DynamoDB table and pass it to output by adding:

```hcl
output "table_arn" {
  value = aws_dynamodb_table.this.arn
}
```

Return to project root directory and open [`main.tf`](../main.tf) file.

Pass each table ARN to output with:

```hcl
output "couses_arn" {
  value = module.courses.table_arn
}

output "authors_arn" {
  value = module.authors.table_arn
}
```

Run `terraform apply -var-file=dev.tfvars` and check command output.

You will see each table ARN as the output of entire project.

> **Note**
> Those outputs in [`main.tf`](../main.tf) you added will not be needed, as we want to pass them to IAM roles only.

## Creating IAM role custom module

Create directory structure `modules/iam/eu-central-1` and navigate to it.

As with DynamoDB custom module, you should copy [`lables.tf`](../labels.tf) to [`main.tf`](../modules/iam/eu-central-1/main.tf) (inside `modules/iam/eu-central-1`) and
[`context.tf`](../context.tf) files to this module.

Next, replace `namespace`, `environment`, `stage`, `label_order` and `delimiter`
module properties with just:

```hcl
module "labels" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.25.0"

  name    = var.name
  context = var.context
}
```

Now, you need to know, how to declare IAM role along with policy.
Copy the code from [this section](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy#example-usage)
and paste it after `labels` module.

Rename `test_policy` to `iam_lambda_policy` and `test_role` to `iam_lambda_role`.

Instead of hardcoded `name` property in role and policy resources, use
`module.labels.id` reference.

Replace `ec2.amazonaws.com` with `lambda.amazonaws.com` in `iam_lambda_role.assume_role_policy`
property.

Next, you need to parametrize `policy` property of `iam_lambda_policy` to
accept different policies for different lambdas.

For this, create [`variables.tf`](../modules/iam/eu-central-1/variables.tf) file and declare `policy` variable:

```hcl
variable "policy" {
  type = string
}
```

This property will accept `jsonencode`'d policy on DynamoDB table.

Now, replace `jsonencode` expression in `policy` property of `iam_lambda_policy` with `var.policy`.

`assume_role_policy` stays unchanged, as we will use our IAM policy only for AWS Lambdas.

Also, you will need ARN of IAM role to be passed to AWS lambda.

For this, create [`outputs.tf`](../modules/iam/eu-central-1/outputs.tf) file
and reference `iam_lambda_role`'s ARN in output:

```hcl
output "lambda_role_arn" {
  value = aws_iam_role.iam_lambda_role.arn
}
```

## Using IAM role custom module

Now, proceed to project root directory and open [`main.tf`](../main.tf) file.

You have to create the first role:

```hcl
module "get-all-authors-lambda-role" {
  source  = "./modules/iam/eu-central-1"
  context = module.base_labels.context
  name    = "get-all-authors-lambda-role"
}
```

Notice, you have not provided required property `policy`.

To do this, assume a policy:

```JSON
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
        "dynamodb:Scan",
      ],
      "Resource" : "ARN of the DynamoDB table"
    }
  ]
}
```

Which allows scanning DynamoDB table.

You need to specify the ARN of `authors` table, taking it's property `table_arn`.

Also, you need to change JSON to Terraform's YAML notation.

Resulting code is expected to look like this:

```hcl
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
```

> **Note**
> Each time you adding `labels` module, you must run `terraform init`
> to install required modules for it.
>
> In this case, you have added `labels` for `iam`.

And now you can test, what changes Terraform detected with command:

```bash
terraform apply -var-file=dev.tfvars
```

You can freely apply the changes.

> **Note**
> You need to know, which actions to list in each role's policy.
>
> There is the list of possible **actions** on DynamoDB table:
>
> - `dynamodb:DeleteItem`
> - `dynamodb:GetItem`
> - `dynamodb:PutItem`
> - `dynamodb:Scan`
> - `dynamodb:UpdateItem`

> **Note**
> If your [`main.tf`](../main.tf) file is too long, you can write
> IAM lambda roles in a separate file, such as [`iam-lambda-roles.tf`](../iam-lambda-roles.tf).

Now, create the rest roles:

- `get-all-courses-lambda-role`
- `get-course-lambda-role`
- `save-course-lambda-role`
- `update-course-lambda-role`
- `delete-course-lambda-role`

with relevant **actions** and `Resource` property, run `terraform init`
and apply changes to your IaC.

You can see final result [in this file](../iam-lambda-roles.tf)

[Next step (Creating AWS Lambdas) →](./lambdas.md)

