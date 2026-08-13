output "ec2_public_ip" {
  value = aws_instance.myEC2.public_ip
}

output "ec2_connection" {
  value = "ssh ec2-user@${aws_instance.myEC2.public_ip}"
}
