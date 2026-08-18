# variables.tf (Root Module)

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "Project Prefix"
  type        = string
  default     = "minipro2-yunjunho"
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public Subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private Subnet CIDRs"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnets" {
  description = "Database Subnet CIDRs"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "db_username" {
  description = "Database Master Username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database Master Password"
  type        = string
  sensitive   = true
  default     = "password"
}

variable "db_name" {
  description = "Database Name"
  type        = string
  default     = "mydb"
}
