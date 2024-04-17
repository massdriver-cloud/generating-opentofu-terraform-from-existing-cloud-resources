resource "aws_appautoscaling_target" "main" {
  count              = local.autoscaling_enabled ? 1 : 0
  max_capacity       = var.availability.max_replicas
  min_capacity       = var.availability.min_replicas
  resource_id        = "cluster:${aws_rds_cluster.main.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource "aws_appautoscaling_policy" "main" {
  count              = local.autoscaling_enabled ? 1 : 0
  name               = var.metadata.name_prefix
  policy_type        = "TargetTrackingScaling"
  resource_id        = "cluster:${aws_rds_cluster.main.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.availability.autoscaling_mode
    }

    scale_in_cooldown  = var.availability.scale_in_cooldown
    scale_out_cooldown = var.availability.scale_out_cooldown
    target_value       = var.availability.target_value
  }

  depends_on = [
    aws_appautoscaling_target.main
  ]
}
