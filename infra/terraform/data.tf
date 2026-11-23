data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_elb_service_account" "main" {}

data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}
