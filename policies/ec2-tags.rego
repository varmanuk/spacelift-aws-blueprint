package spacelift

deny[msg] {
  input.resource_type == "aws_instance"
  not input.tags.env
  msg = "EC2 must have env tag"
}

deny[msg] {
  input.resource_type == "aws_instance"
  not input.tags.owner
  msg = "EC2 must have owner tag"
}