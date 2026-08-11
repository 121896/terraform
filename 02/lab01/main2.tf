#
# EC2(SG, user_data(web server), keypair) 생성
#
# * SG(22/tcp, 80/tcp, 443/tcp)
# * keypair
# * EC(user_data(web server))

# 1) SG(22/tcp, 80/tcp, 443/tcp)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "mySG" {
  name        = "mySG"
  description = "Allow SSH,WEB inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myVPC.id

  tags = {
    Name = "mySG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "mySG_22" {
  security_group_id = aws_security_group.mySG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "mySG_80" {
  security_group_id = aws_security_group.mySG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "mySG_443" {
  security_group_id = aws_security_group.mySG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "mySG_allow_all" {
  security_group_id = aws_security_group.mySG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# 2) keypair
# CMD: ssh keygen -t rsa -N "" ~/.ssh/mykeypair
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = file("~/.ssh/mykeypair.pub")
}

# 3) EC2(user_data(web server))
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# * 새로 생성된 Subnet(myPubSN)에서 EC2 인스턴스 생성 - subnet_id
# * 새로 만든 mykeypair를 사용하여 EC2 인스턴스 생성 - key_name
# * 새로 만든 mySG를 사용하여 EC2 인스턴스 생성 - vpc_security_group_ids
# * user_data -> user_data_replace_on_change
resource "aws_instance" "myEC2" {
  ami                         = "ami-048f644e868baa0e8"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.myPubSN.id
  key_name                    = "mykeypair"
  vpc_security_group_ids      = [aws_security_group.mySG.id]
  user_data_replace_on_change = true
  user_data                   = <<-EOF
        #!/bin/bash
        dnf install -y httpd mod_ssl
        echo "My Web Server Test Page" > /var/www/html/index.html
        systemctl enable --now httpd
        EOF

  tags = {
    Name = "myEC2"
  }
}
