resource "aws_appautoscaling_target" "ecs-autoscaling-target-service-02" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.cluster-01.name}/${aws_ecs_service.service-02.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs-policy-autoscaling-service-02" {
  name               = "ecs-policy-autoscaling-service-02"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs-autoscaling-target-service-02.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs-autoscaling-target-service-02.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs-autoscaling-target-service-02.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 60
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}