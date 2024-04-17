resource "aws_iam_role" "rds_enhanced_monitoring" {
  count              = local.enhanced_monitoring_enabled ? 1 : 0
  name               = "${var.metadata.name_prefix}-rds-enhanced-monitoring"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring[0].json
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count      = local.enhanced_monitoring_enabled ? 1 : 0
  role       = aws_iam_role.rds_enhanced_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  count = local.enhanced_monitoring_enabled ? 1 : 0
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:db:${var.metadata.name_prefix}*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        data.aws_caller_identity.current.account_id
      ]
    }
  }
}
