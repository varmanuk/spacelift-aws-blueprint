terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Get latest AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Random suffix for S3
resource "random_id" "suffix" {
  byte_length = 4
}

# EC2 Instance
resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.nano"

  tags = {
    Name    = "spacelift-ec2_drift-demo"
    env     = var.env
    owner   = var.owner
    testtag = "true"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "spacelift-demo-${var.env}-${random_id.suffix.hex}"

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