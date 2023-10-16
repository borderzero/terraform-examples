output "vpc_id" {
  value = aws_vpc.main.id
}

output "allow_all_vpc_id" {
  value = aws_security_group.allow_all_vpc.id
}

output "private_subnet_ids" {
  value = {
    private_subnet_id_1 = aws_subnet.private_subnet_1.id
    private_subnet_id_2 = aws_subnet.private_subnet_2.id
  }
}

output "ecs" {
  # map for cluster and service names
  value = {
    cluster1 = {
    cluster_name = aws_ecs_cluster.ecs-cluster1.name
    service_name = aws_ecs_service.ecs-service1.name
    }
  }
}

output "alb" {
  value = {
    alb_name = aws_lb.nginx_alb.name
    alb_arn  = aws_lb.nginx_alb.arn
    alb_dns_name = aws_lb.nginx_alb.dns_name
  }
}

output "rds_instance" {
  value = {
    address = aws_db_instance.rds.address
    port    = aws_db_instance.rds.port
    username_path = "from:aws:ssm:${local.rds-username-param-path}"
    password_path = "from:aws:ssm:${local.rds-password-param-path}"
  }
}

output "ec2_instances" {
  value = { for idx, instance in aws_instance.ec2_instance : 
    "server${format("%01d", idx + 1)}" => {
      id        = instance.id,
      private_ip = instance.private_ip
    }
  }
}
