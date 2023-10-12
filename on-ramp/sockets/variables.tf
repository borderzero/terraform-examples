variable "border0_token" {
  description = "Border0 Token"
  default     = ""
}

variable "name_prefix" {
  description = "Name prefix"
  default     = ""
}

variable "border0_connector_id" {
  description = "Border0 Connector ID"
  default     = ""
}

variable "border0_policy_id" {
  description = "Border0 policy ID"
  default     = ""
}

variable "ecs" {
  description = "ECS Cluster and Service names"
  type = map(string)
}

variable "rds_instance" {
  description = "RDS Instance"
  type = map(string)
}

variable "ec2_instances" {
  description = "EC2 Instances"
  type = map(map(string))
}

data "aws_region" "current" {}
variable "default_tags" {}