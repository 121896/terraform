# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Output declarations

# vpc_id
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest?tab=outputs
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "New VPC ID"
}

# LB DNS name
# https://registry.terraform.io/modules/terraform-aws-modules/elb/aws/latest?tab=outputs
output "lb_url" {
  value       = "http://${module.elb_http.elb_dns_name}"
  description = "LB DNS name"
}

# EC2 instance count
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
output "ec2_count" {
  value       = length(module.ec2_instances.instance_ids)
  description = "EC2 Instance Count"
}

# DB username
# DB password
# https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest?
output "db_username" {
  value       = aws_db_instance.database.username
  description = "DB username"
  sensitive   = true
}

output "db_password" {
  value       = aws_db_instance.database.password
  description = "DB password"
  sensitive   = true
}
