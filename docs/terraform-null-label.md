# Terraform Null Label

The next step is to configure `lables` module, using [cloudposse/terraform-null-label](https://github.com/cloudposse/terraform-null-label).

For this, navigate to [Simple example](https://github.com/cloudposse/terraform-null-label#simple-example) section and copy this code
to [`labels.tf`](../labels.tf) file.

## Pinning module to specific version

```hcl
module "eg_prod_bastion_label" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"
  # ...
}
```

As the comment suggests, it's recommended to pin every label module to a specific version.

We'll set `0.25.0` for current project, which result in the next contents:

```hcl
module "eg_prod_bastion_label" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.25.0"
  # ...
}
```

## Naming label module

Rename this module to `labels` or any other name, which tell you it's the base labels module:

```hcl
module "labels" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.25.0"
  # ...
}
```

## Declaring `context` module and variable

To declare `context` variable for `labels` module, copy the contents of [this file](https://github.com/cloudposse/terraform-null-label/blob/master/examples/complete/context.tf)
to [`context.tf`](../context.tf).

> **Warning**
> Some variables in [`context.tf`](../context.tf) are already declared in [`vars.tf`](../vars.tf).
> This means you **should** delete [`vars.tf`](../vars.tf) file.
> Otherwise, `terraform` will warn you about duplicate variable declaration.

## Using context in `labels` module

Your [`labels.tf`](../labels.tf) file looks like this:

```hcl
module "base_labels" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.25.0"

  namespace  = "eg"
  stage      = "prod"
  name       = "bastion"
  attributes = ["public"]
  delimiter  = "-"

  tags = {
    "BusinessUnit" = "XYZ",
    "Snapshot"     = "true"
  }
}
```

Replace hardcoded `namespace` and `stage` with appropriate vars, any other properties become commented
. The resulting [`labels.tf`](../labels.tf) should have the next contents:

```hcl
module "base_labels" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.25.0"

  namespace = var.namespace
  stage     = var.stage
  # name       = "bastion"
  # attributes = ["public"]
  # delimiter  = "-"

  # tags = {
  #   "BusinessUnit" = "XYZ",
  #   "Snapshot"     = "true"
  # }
}
```

## Init `labels` module

Finally, you should init `labels` module, as it references `cloudposse/label/null` as `source`, with command:

```bash
terraform init
```


