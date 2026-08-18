# modules/ec2/outputs.tf

output "asg_id" {
  value = aws_autoscaling_group.this.id
}
