# Prerequisites

> **Note**
> This section assumes, you have installed `aws-vault` and have added profile to it. `aws-vault` profile name is referenced as `YOUR_PROFILE`.

All the next sections imply, you started a subshell with `aws-vault` credentials, like this:

```bash
aws-vault exec YOUR_PROFILE --no-session
```

`--no-session` switch is needed, if AWS gives you `InvalidClientTokenId` error.


In subshell `aws-vault` injects environment variables, such as `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_REGION`.

> **Note**
> `AWS_REGION` env var is set only if you set `AWS_DEFAULT_REGION` env var.
> To set it permanently in your `.bashrc`, follow [Setting AWS env vars](#setting-aws-env-vars)) guide.

## Setting AWS env vars

To set AWS env vars, you have to open your `~/.bashrc` file with favourite editor.

For example, opening it in VS Code looks like this:

```bash
code ~/.bashrc
```

Next, you use `export` bash keyword to make env var, followed by `VARIABLE_NAME` and its value.

For example, to set `AWS_DEFAULT_REGION` to `eu-central-1` you append the next contents:

```bash
export AWS_DEFAULT_REGION=eu-central-1
```

Same applies to any other env vars, those might not be related to AWS.

To load recently added env vars, you `source` your `.bashrc` file:

```bash
source ~/.bashrc
```

To check, if variable is accessible in current shell, type:

```bash
env | grep -o AWS.*
```

Finally, try running a subshell with `aws-vault` and check with previous command, which AWS variables are set.

[Next step (Selecting Terraform version) →](./tfswitch.md)

