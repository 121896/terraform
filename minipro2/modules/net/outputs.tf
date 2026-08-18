# modules/net/outputs.tf

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "db_subnet_group_name" {
  value = module.vpc.database_subnet_group_name
}

output "alb_sg_id" {
  value = module.alb_sg.security_group_id
}

output "ec2_sg_id" {
  value = module.ec2_sg.security_group_id
}

output "db_sg_id" {
  value = module.db_sg.security_group_id
}
