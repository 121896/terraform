#
# Provider
#
provider "aws" {
  region = "us-east-2"
}

#
# VPC - PubSubnet(PubRT)
#
# * VPC 생성
# * IGW 생성과 VPC 연결
# * PubSubnet 생성
# * PubRT 생성과 설정, 연결

# 1) VPC 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# * dns hostname
resource "aws_vpc" "myVPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "myVPC"
  }
}

# 2) IGW 생성과 VPC 연결
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "myIGW"
  }
}

# 3) PubSubnet 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# 퍼블릭 IPv4 주소 자동 할당 활성화
resource "aws_subnet" "myPubSubnet" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "myPubSubnet"
  }
}

# 4) PubRT 생성과 설정, 연결


