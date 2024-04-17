variable "region" {
  type = string
}

variable "metadata" {
  type = object({
    name_prefix  = string
    default_tags = map(string)
  })
}

variable "networking" {
  type = object({
    subnet_ids = list(string)
    vpc_id     = string
  })
}

variable "availability" {
  type = object({
    autoscaling_mode   = string # DISABLED, RDSReaderAverageDatabaseConnections, RDSReaderAverageCPUUtilization
    min_replicas       = number
    max_replicas       = number
    scale_in_cooldown  = number
    scale_out_cooldown = number
    target_value       = number
  })
}

variable "backup" {
  type = object({
    retention_period    = number
    skip_final_snapshot = bool
  })
}

variable "database" {
  type = object({
    deletion_protection = bool
    instance_class      = string
    version             = string
    ca_cert_identifier  = string
  })
}

variable "observability" {
  type = object({
    enable_cloudwatch_logs_export         = bool
    enhanced_monitoring_interval          = number
    performance_insights_retention_period = number
  })
}
