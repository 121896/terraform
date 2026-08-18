# main.tf (Root Module)
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Custom Module: net (VPC, Subnet 생성)
module "net" {
  source = "./modules/net"

  project_name     = var.project_name
  vpc_cidr         = var.vpc_cidr
  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets
}

# 2. Registry Module: Application Load Balancer
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name               = "${var.project_name}-alb"
  load_balancer_type = "application"
  vpc_id             = module.net.vpc_id
  subnets            = module.net.public_subnets
  security_groups    = [module.net.alb_sg_id]

  target_groups = [
    {
      name_prefix      = "web-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/health.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
}

# 3. Registry Module: RDS Aurora Cluster
module "db" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 8.0"

  name = "${var.project_name}-db-cluster"

  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.04.1"
  
  instance_class = "db.t3.medium"
  instances = {
    1 = { instance_class = "db.t3.medium" }
    2 = { instance_class = "db.t3.medium" }
  }

  vpc_id                 = module.net.vpc_id
  db_subnet_group_name   = module.net.db_subnet_group_name
  vpc_security_group_ids = [module.net.db_sg_id]

  master_username     = var.db_username
  master_password     = var.db_password
  database_name       = var.db_name
  skip_final_snapshot = true
}

# 4. Custom Module: ec2 (EC2 생성)
module "ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name
  instance_type     = var.instance_type
  private_subnets   = module.net.private_subnets
  ec2_sg_id         = module.net.ec2_sg_id
  target_group_arns = module.alb.target_group_arns

  db_endpoint       = module.db.cluster_endpoint
  db_username       = var.db_username
  db_password       = var.db_password
  db_name           = var.db_name
}
