# Create the ASG and attach to the ASG
resource "aws_ecs_capacity_provider" "main" {
  name = local.name_prefix

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.main.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      instance_warmup_period    = var.cp_instance_warmup_period
      minimum_scaling_step_size = var.cp_min_scaling_step_size
      maximum_scaling_step_size = var.cp_max_scaling_step_size
      target_capacity           = var.cp_target_capacity
      status                    = "ENABLED"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Attach CP to the ECS cluster
resource "aws_ecs_cluster_capacity_providers" "attach" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = [
    aws_ecs_capacity_provider.main.name
  ]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    weight            = 1
    base              = 0
  }

}
