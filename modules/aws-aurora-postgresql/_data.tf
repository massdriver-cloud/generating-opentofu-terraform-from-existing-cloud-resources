data "aws_caller_identity" "current" {}

data "aws_vpc" "selected" {
  id = var.networking.vpc_id
}
