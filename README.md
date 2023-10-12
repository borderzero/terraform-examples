# Quick On-Ramp Border0 with Terraform in AWS
This Terraform code will let you get started with Border0 in AWS in a matter of minutes.
For those who are hands-in we have automated the process of creating a Border0 enabled infrastructure as a great way to get started with Border0 and see how it works.
## Environment prep and assumptions
Before we start we need to make sure our environment is set up right.
We will require a functioning terraform software with AWS and Border0 credentials

1. [Border0 Account](https://docs.border0.com/docs/signup) and [API Token](https://docs.border0.com/docs/creating-access-token), you can create on [Access Tokens](https://portal.border0.com/organizations/current?tab=new_token) Portal Page

2. AWS Account, Access Key and Secret, you can create them here: [AWS Access Keys](https://console.aws.amazon.com/iam/home?#/security_credentials)

3. Terraform, if you don't already have it, here is [Hashicpro Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Terraform Module Diagram
![Terraform Module Diagram](diagram.png)
## Running the Terraform On-Ramp Module
1. Clone this repo:
```
git clone https://github.com/borderzero/terraform-examples.git
```

2. Switch to the terraform-examples/ directory:
```
cd terraform-examples
```
3. Update the ``variables.tf`` file with your Border0 API Token and AWS Access Key and Secret

    Set the following variables:
- MY_BORDER0_TOKEN - Border0 API Token
- MY_AWS_ACCESS_KEY - AWS Access Key
- MY_AWS_SECRET_KEY - AWS Secret Key
- MY_AWS_REGION - AWS Region


4. Initialise the Terraform:
```
terraform init
```
5. Run the Terraform module:
```
terraform apply
```
6. Once you are done with the Terraform module we can run cleanup:
```
terraform destroy
```
