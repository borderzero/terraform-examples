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
    cluster_name = aws_ecs_cluster.ecs-cluster1.name
    service_name = aws_ecs_service.ecs-service1.name
  }
}
  
output "rds_instance" {
  value = {
    address = aws_db_instance.rds.address
    port    = aws_db_instance.rds.port
    username_path = "from:aws:ssm:${var.smm-db-username-path}"
    password_path = "from:aws:ssm:${var.smm-db-password-path}"
  }
}

output "ec2_instances" {
  value = { for idx, instance in aws_instance.ec2_instance : 
    "instance${format("%02d", idx + 1)}" => {
      id        = instance.id,
      private_ip = instance.private_ip
    }
  }
}
