# cloud-technologies-project

This repository will contain code for "Cloud Technologies" labs.

## Setup

Use Terraform CLI to manage your AWS IaC. There are 3 commands available: `init`, `plan`, `apply`.

`init` command will generate `.terraform.lock.hcl` file and install required modules locally.

`plan` will show information about IaC changes, that will apply after `apply`.

1. Init provider

    - copy code for AWS provider to `provider.tf` from [this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) page.    
    - run `terraform init` to install the provider
    - check what `terraform plan` outputs

