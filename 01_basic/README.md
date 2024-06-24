# Getting started with Border0 Terraform Provider
Our basic Terraform code will set you on your automation journey with Border0. 
We have automated basic Border0 infrastructure you can quickly run on your local machine.

## prerequisites prep and assumptions
1. [Border0 Account](https://docs.border0.com/docs/signup) and a Service Accout and [API Token](https://portal.border0.com/iam?tab=service-accounts)

2. Terraform tooling (if you don't already have it) here is [Hashicorp Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)

#### 1. Clone this repo:
```
git clone https://github.com/borderzero/terraform-examples.git
```

#### 2. Switch to the terraform-examples/01_basic directory:
```
cd terraform-examples/01_basic
```

#### 3. Border0 Credentials Setup

Create Border0 Service Account and Token, here is the [guide](https://docs.border0.com/docs/service-accounts)

Once you create your token you can set it up in one of the following ways:

1. Update the ``variables.tf`` file variable ``BORDER0_TF_TOKEN`` with your token

2. alternatively, you can export the token as an environment variable
    ```
    export TF_VAR_BORDER0_TF_TOKEN="ey...9Iw"
    ```

#### 6. Initialize and apply Terraform:
```
terraform init
```
```
terraform apply -auto-approve
```
Once the Terraform module is done the Output will show the following:

```
...
Outputs:

everything = {
  "You can now run your CLI script" = "./runme.sh"
}
```
Freel free to explore your brand new Border0 infrastructure by running the `./runme.sh` script<br>
At the same time can navigate to the Border0 Portal and see the newly created infrastructure:
- [Client Portal](https://client.border0.com/#/login)
[![Client Portal](client-portal.png)](https://client.border0.com)
- [Admin Portal](https://portal.border0.com/mysockets)
[![Admin Portal](admin-portal.png)](https://portal.border0.com)

#### 7. Perform a cleanup for Terraform:
```
terraform destroy
```
