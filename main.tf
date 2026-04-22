provider "aws" {
  region = var.region
}

# EC2 Instance
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # update for your region
  instance_type = "t3.micro"

  tags = {
    Name    = "spacelift-ec2"
    env     = var.env
    owner   = var.owner
    testtag = "true"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "spacelift-demo-${var.env}"

  tags = {
    env   = var.env
    owner = var.owner
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}