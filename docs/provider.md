# Init provider

1. Copy code for AWS provider to `provider.tf` from [this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) page
2. While using `aws-vault`, you don't have to specify `region` property, as `aws-vault` injects `AWS_REGION` environment variable for you

    > **Note**
    > `AWS_REGION` env var is set only if you set `AWS_DEFAULT_REGION` env var.
    > To set it permanently in your `.bashrc`, follow [Setting AWS env vars](./prerequisites.md#setting-aws-env-vars) guide.
        
    So, `provider.tf` looks like this:

    ```
    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "4.59.0"
        }
      }
    }

    provider "aws" {}

    ```

    This file is listed in `.gitignore`, so it stays only on your machine.

3. Use `terraform` command to manage your AWS IaC. There are 3 commands available: `init`, `plan`, `apply`.

    - `init` command will generate `.terraform.lock.hcl` file and install required modules locally (if there are some).
    - `plan` will show information about IaC changes (difference between local Terraform IaC setup and AWS in this case), that will apply after `apply`.
    - `apply` will apply local IaC changes to AWS (in this case).

    So, run `terraform init` to install required modules for `provider.tf`.

4. Check what `terraform plan` outputs

