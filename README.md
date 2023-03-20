# cloud-technologies-project

This repository will contain code for "Cloud Technologies" labs.

## Setup

This section suggests you started shell with `aws-vault` credentials, like this:

```bash
aws-vault exec YOUR_PROFILE --no-session
```

In subshell `aws-vault` injects environment variables, such as `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_REGION`.

Use Terraform CLI to manage your AWS IaC. There are 3 commands available: `init`, `plan`, `apply`.

`init` command will generate `.terraform.lock.hcl` file and install required modules locally.

`plan` will show information about IaC changes, that will apply after `apply`.

1. Init provider

    - copy code for AWS provider to `provider.tf` from [this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) page
    - while using `aws-vault`, you don't have to specify `region` property, as `aws-vault` injects `AWS_REGION` environment variable for you

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

    - run `terraform init` to install the provider
    - check what `terraform plan` outputs

