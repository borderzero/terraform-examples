# Getting started with Border0 Terraform Provider
Our basic Terraform code will set you on your automation journey with Border0. 
We have automated basic Border0 infrastructure you can quickly run on your local machine.

## prerequisites prep and assumptions
Before we get started, make sure you have the following:

1. [Border0 Account](https://docs.border0.com/docs/signup) - Sign up for a Border0 account, it's free to sign up!

2. Border0 cli tool (if you don't already have it) here is [Border0 Quick-Start Guide](https://docs.border0.com/docs/quick-start)

2. Terraform tooling (if you don't already have it) here is [Hashicorp Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)

#### 1. Clone this repo:
```
git clone https://github.com/borderzero/terraform-examples.git
```

#### 2. Switch to the terraform-examples/01_basic directory:
```
cd terraform-examples/01_basic
```
#### 3. Border0 Login

Login to Border0 using the Border0 CLI:
```
border0 login
```
Now we set the Border0 API Token as an environment variable for Terraform to use.
```
export TF_VAR_BORDER0_TF_TOKEN=$(cat ~/.border0/token)
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
