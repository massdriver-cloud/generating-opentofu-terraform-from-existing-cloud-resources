# Only generate a username if its NOT a restore
# Restoring w/ a different username will cause a recreate on the _next_ provision
# https://github.com/hashicorp/terraform-provider-aws/pull/9505/files#diff-9d869fc908da636b09ac45e62cd373de7223e04ab7a2279385d6ea31004fcbacR92
resource "random_pet" "root_username" {
  count     = local.has_source_snapshot ? 0 : 1
  separator = ""
}

resource "random_password" "root_password" {
  length      = 16
  lower       = true
  numeric     = true
  special     = false
  upper       = true
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
}

resource "random_id" "snapshot_identifier" {
  byte_length = 4
}
