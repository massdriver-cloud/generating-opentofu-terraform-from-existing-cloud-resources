resource "aws_db_subnet_group" "main" {
  name        = var.metadata.name_prefix
  description = "Aurora PostgreSQL ${var.metadata.name_prefix}"
  subnet_ids  = var.networking.subnet_ids
}

resource "aws_security_group" "main" {
  vpc_id      = var.networking.vpc_id
  name_prefix = "${var.metadata.name_prefix}-"
  description = "Control traffic to/from Aurora PostgreSQL ${var.metadata.name_prefix}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "vpc_ingress" {
  count       = 1
  description = "From allowed CIDRs"
  type        = "ingress"
  from_port   = local.postgresql.port
  to_port     = local.postgresql.port
  protocol    = local.postgresql.protocol
  cidr_blocks = [data.aws_vpc.selected.cidr_block]

  security_group_id = aws_security_group.main.id
}
