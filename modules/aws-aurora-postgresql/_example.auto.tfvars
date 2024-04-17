region = "us-west-2"

metadata = {
  name_prefix = "webinar-test-opentofu"
  default_tags = {
    "Webinar"     = "opentofu"
    "Environment" = "test"
  }
}

## Uncomment & set 
# networking = {
#   # vpc_id     = REPLACE_ME ~ "vpc-0004a66b0b3f00ba4"
#   # subnet_ids = REPLACE ME ~ ["subnet-0004a66b0b3f00ba4"]
# }

availability = {
  autoscaling_mode   = "DISABLED"
  min_replicas       = 0
  max_replicas       = 0
  scale_in_cooldown  = 0
  scale_out_cooldown = 0
  target_value       = 0
}

backup = {
  retention_period    = 7
  skip_final_snapshot = false
}

database = {
  deletion_protection = false
  instance_class      = "db.serverless"
  version             = "16.1"
  ca_cert_identifier  = "rds-ca-2019"
  serverless_scaling = {
    min_capacity = 0.5
    max_capacity = 1.0
  }
}

observability = {
  enable_cloudwatch_logs_export         = false
  enhanced_monitoring_interval          = 0
  performance_insights_retention_period = 7
}
