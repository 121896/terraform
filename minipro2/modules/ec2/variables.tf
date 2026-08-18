variable "project_name" { type = string }
variable "instance_type" { type = string }
variable "private_subnets" { type = list(string) }
variable "ec2_sg_id" { type = string }
variable "target_group_arns" { type = list(string) }

variable "db_endpoint" { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string }
variable "db_name" { type = string }
