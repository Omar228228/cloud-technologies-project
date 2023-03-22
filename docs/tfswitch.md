# Selecting Terraform version

It is recommended to install [`tfswtich`](https://github.com/warrensbox/terraform-switcher/) to easily switch between Terraform versions.

## Selecting Terraform version in project

Create `.terraform-version` file and write to it appropriate version (`1.4.0`):

```
echo 1.4.0 > .terraform-version
```

## Installing Terraform

`tfswitch` will detect `.terraform-version` file and install `1.4.0` version for you.

For this, just run:

```bash
tfswitch
```

Also it prints the path, where Terraform binary is installed.
This is important, because by default (logged as user and not `root`) Terraform is installed to `/home/USERNAME/bin`.

As in [Setting AWS env vars](./prerequisites.md#setting-aws-env-vars) section, you must set some variable to tell the system, that terraform lives there, so you don't need to specify full path to `terraform` executable, when trying to run it.

For that, open `.bashrc` with your favourite editor:

```bash
code ~/.bashrc
```

And append the path, printed by tfswitch to `PATH` variable by adding:

```bash
export PATH=$PATH:/home/USERNAME/bin
```

Replace `USERNAME` with your username, and save the file. Make sure you appended the same path `tfswitch` printed you, in some cases it might output `/home/USERNAME/.bin` (see that `.`?)

Finally, check terraform version with:

```bash
terraform -v
```

If everything is ok, it shows the next:

```
Terraform v1.4.0
on linux_amd64
+ provider registry.terraform.io/hashicorp/aws v4.59.0

Your version of Terraform is out of date! The latest version
is 1.4.2. You can update by downloading from https://www.terraform.io/downloads.html
```

[Next step (Init provider) →](./provider.md)

