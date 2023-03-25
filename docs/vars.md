# Declaring variables

> **Note**
> In this section you declare global variables, that will be used
> by other modules, such as `label`.

## Variable declaration

You start declaring variables by creating [`vars.tf`](../vars.tf) file
, which declares each variable type.

Use the next syntax to declare variable type:

```hcl
variable "var_name" {
  type = var_type
}
```

Replace `var_name` with your variable name and `var_type` with appropriate variable type.

List of variable types available on [this page](https://developer.hashicorp.com/terraform/language/expressions/types).

In the context of current lab, it's assumed you finish with the next [`vars.tf`](../vars.tf) contents:

```hcl
variable "namespace" {
  type = string
}

variable "stage" {
  type = string
}

variable "environment" {
  type = string
}

variable "label_order" {
  type = list(string)
}

variable "delimiter" {
  type = string
}
```

## Variable definition

For convenience, variables are defined in separate file according to stage.

For example, in for `dev` stage, `dev.tfvars` file is used.

Use the next syntax for defining a variable:

```hcl
var_name = var_value
```

Replace `var_name` with your variable name and `var_value`
with appropriate variable value, according to its `var_type`.

Finally, you will finish with [`dev.tfvars`](../dev.tfvars) having the next contents:

```hcl
namespace   = "ct"
stage       = "dev"
environment = "lpnu"
label_order = ["stage", "namespace", "environment", "name", "attributes"]
delimiter   = "-"
```

> **Note**
> You can change `namespace` to `cloud-technologies` or something like that.

## Defining variables for other stages

You might want to define variables with other values in other stages
, so create [`prod.tfvars`](../prod.tfvars) and [`stage.tfvars`](../stage.tfvars) by:

```bash
cp dev.tfvars prod.tfvars && cp dev.tfvars stage.tfvars
```

In those files change `stage` variable value to appropriate stage.
Leave other variables unchanged.

For example, [`prod.tfvars`](../prod.tfvars) will have the next contents:

```hcl
namespace   = "cloud_technologies_project"
stage       = "prod"
environment = "lpnu"
label_order = ["stage", "namespace", "environment", "name", "attributes"]
delimiter   = "-"
```

Note, that `stage = "dev"` is replaced with `stage = "prod"`.

