package spacelift

deny[msg] {
  input.resource_type == "aws_s3_bucket"
  input.public == true
  msg = "S3 bucket must not be public"
}