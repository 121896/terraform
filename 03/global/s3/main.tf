provider "aws" {
  region = "us-east-2"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = "bucket-yjh-1218"

  tags = {
    Name = "mybucket"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
resource "aws_dynamodb_table" "mylocks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-locks"
  }
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.mybucket.arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.mylocks.name
}
