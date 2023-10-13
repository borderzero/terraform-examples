# Quick On-Ramp Border0 with Terraform in AWS
This Terraform code will let you get started with Border0 in AWS in a matter of minutes.
For those who are hands-on we have automated the process of creating a Border0 enabled infrastructure as a great way to get started with Border0 and see how it works.
## Environment prep and assumptions
Before we start we need to make sure our environment is set up right.

We will require a functioning terraform software with AWS and Border0 credentials

1. [Border0 Account](https://docs.border0.com/docs/signup) and [Member API Token](https://docs.border0.com/docs/creating-access-token), you can create on [Member Tokens](https://portal.border0.com/organizations/current?tab=new_token) Portal Page

2. AWS Account, Access Key and Secret, you can create them here: [AWS Access Keys](https://console.aws.amazon.com/iam/home?#/security_credentials)

3. Terraform, if you don't already have it, here is [Hashicpro Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)

> **Caution:** This code creates resources in your AWS account! Once you are finish testing, remove these resources to prevent unnecessary AWS costs. You can delete resources manually or with `terraform destroy`.

## Terraform Module Diagram
![Terraform Module Diagram](diagram.png)
## Running the Terraform On-Ramp Module
We will be creating a Border0 enabled infrastructure in AWS with the following resources:
- VPC
    - 2 private and 1 public subnet
    - Internet and NAT Gatewas
    - Security Groups
- RDS Instance
- ECS Cluster, Task and Service Definition
- Client/Origin EC2 Instances
- Border0 Connector EC2 Instance


#### 1. Clone this repo:
```
git clone https://github.com/borderzero/terraform-examples.git
```

#### 2. Switch to the terraform-examples directory:
```
cd terraform-examples
```
#### 3. Border0 Credentials setup

Update the ``variables.tf`` file with your Border0 API Token
<br>Set the ``MY_BORDER0_TOKEN`` variable to your Border0 API [Member Token](https://portal.border0.com/organizations/current?tab=new_token)

#### 4. AWS Credentials setup

If you happen to have your AWS default credentials set up in your environment, and you want to use them... you are good to go! Go to step 5.

Otherwise, you can set up your AWS credentials in one of the following ways:

#### 4a. environment variables.
```
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_REGION="us-west-2"
export AWS_DEFAULT_REGION="us-west-2"
```
- SSO provider, and profiles (if you have those)
```
aws --profile=my-dev-account-profile sso login
export AWS_PROFILE=my-dev-account-profile
```
more info on terraform aws provider [docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

#### 4b. Static variables

Update the ``variables.tf`` file with your Border0 API Token and AWS Access Key and Secret
<br>Set the following variables:
- MY_AWS_ACCESS_KEY - AWS Access Key
- MY_AWS_SECRET_KEY - AWS Secret Key
- MY_AWS_REGION - AWS Region

Once you have those variables defined uncomment aws profider ``region, access_key, secret_key`` settings in the ``main.tf`` file

  
#### 5. Initialise the Terraform:
```
terraform init
```
#### 6. Run the Terraform module:
```
terraform plan && terraform apply
```
Once the Terraform module is done you can navigate to the Border0 Portal and see the newly created infrastructure 
[Admin Portal](https://portal.border0.com/mysockets) and [Client Portal](https://client.border0.com/#/login)

#### 7. Optioanlly, run cleanup for Terraform module:
```
terraform destroy
```
