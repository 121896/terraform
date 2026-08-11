# 작업 계획
# * NAT Gateway 생성(Public Subnet)
# * Private Subnet 생성
# * Private Route Table 생성 및 설정
# * SG 생성
# * EC2 생성

# 1) NAT Gateway 생성(Public Subnet)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
# * EIP 생성
# * Public Subnet에 NAT Gateway 생성
resource "aws_eip" "myEIP" {
  domain = "vpc"
  #depends_on                = [aws_internet_gateway.gw]

  tags = {
    Name = "myEIP"
  }
}

resource "aws_nat_gateway" "myNATGW" {
  allocation_id = aws_eip.myEIP.id
  subnet_id     = aws_subnet.myPubSN.id

  tags = {
    Name = "myNATGW"
  }

  depends_on = [aws_internet_gateway.myIGW]
}

# 2) Private Subnet 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# * 새로 생성된 myVPC에 Private Subnet 생성
resource "aws_subnet" "myPriSN" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "myPriSN"
  }
}

# 3) Private Route Table 생성 및 설정
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table" "myPriRT" {
  vpc_id = aws_vpc.myVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.myNATGW.id
  }

  tags = {
    Name = "myPriRT"
  }
}

resource "aws_route_table_association" "myPriRTassoc" {
  subnet_id      = aws_subnet.myPriSN.id
  route_table_id = aws_route_table.myPriRT.id
}

# 4) SG 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# * SG(22/tcp, 80/tcp, 443/tcp)
resource "aws_security_group" "mySG2" {
  name        = "mySG2"
  description = "Allow SSH,WEB inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myVPC.id

  tags = {
    Name = "mySG2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "mySG2_22" {
  security_group_id = aws_security_group.mySG2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "mySG2_80" {
  security_group_id = aws_security_group.mySG2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "mySG2_443" {
  security_group_id = aws_security_group.mySG2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "mySG2_allow_all" {
  security_group_id = aws_security_group.mySG2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# 5) EC2 생성
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# * 새로 생성된 SG에서 EC2 인스턴스 생성 - vpc_security_group_ids
# * 새로 생성된 myPriSN에서 EC2 인스턴스 생성 - subnet_id
# * mykeypair - key_name
# * user_data -> user_data_replace_on_change
resource "aws_instance" "myEC2-2" {
  ami                         = "ami-048f644e868baa0e8"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.myPriSN.id
  key_name                    = "mykeypair"
  vpc_security_group_ids      = [aws_security_group.mySG2.id]
  user_data_replace_on_change = true
  user_data                   = <<-EOF
        #!/bin/bash
        dnf install -y httpd mod_ssl
        echo "My Web Server Test Page" > /var/www/html/index.html
        systemctl enable --now httpd
        EOF

  tags = {
    Name = "myEC2-2"
  }
}
