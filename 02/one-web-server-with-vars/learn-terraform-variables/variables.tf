# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Variable declarations
variable "aws_region" {
  default     = "us-east-2"
  type        = string
  description = "AWS region"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "VPC CIDR block"
}

variable "instance_count" {
  default     = 2
  type        = number
  description = "EC2 instance count"
}

variable "disable_vpn_gateway" {
  default     = false
  type        = bool
  description = "Disable VPN gateway"
}

# variable "public_subnets" {
#   default     = ["10.0.1.0/24", "10.0.2.0/24"]
#   type        = list(string)
#   description = "Public Subnet List"
# }

variable "public_subnet_cidr_blocks" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24"
  ]
  type        = list(string)
  description = "Public Subnet CIDR Blocks"
}

variable "subnet_count" {
  default     = 2
  type        = number
  description = "Public Subnet Count"
}

variable "private_subnet_cidr_blocks" {
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
    "10.0.105.0/24",
    "10.0.106.0/24",
    "10.0.107.0/24",
    "10.0.108.0/24"
  ]
  type        = list(string)
  description = "Private Subnet CIDR Blocks"
}

variable "resource_tags" {
  default = {
    project     = "project-alpha",
    environment = "dev"
  }
  type        = map(string)
  description = "Resource Tags"
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance Type(ex: t2.micro)"
}
