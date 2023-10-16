module "infrastructure" {
  source       = "./infrastructure"
  default_tags = local.default_tags
  prefix       = var.prefix
}

module "connector" {
  source        = "./connector"
  default_tags  = local.default_tags
  prefix        = var.prefix
  access-email  = var.access-email

  # VPC, subnets, and security groups from infrastructure
  private_subnet_ids = module.infrastructure.private_subnet_ids
  allow_all_vpc_id   = module.infrastructure.allow_all_vpc_id
}

module "sockets" {
  source        = "./sockets"
  default_tags  = local.default_tags
  prefix        = var.prefix

  # ECS, RDS, and EC2 instances from infrastructure
  ecs           = module.infrastructure.ecs
  alb           = module.infrastructure.alb
  rds_instance  = module.infrastructure.rds_instance
  ec2_instances = module.infrastructure.ec2_instances

  # connector and policy IDs from connector
  border0_connector_id = module.connector.border0_connector_id
  border0_policy_id    = module.connector.border0_policy_id
}
