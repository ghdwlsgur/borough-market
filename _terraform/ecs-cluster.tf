resource "aws_ecs_cluster" "borough-market" {
  name = local.aws_ecs_cluster_name
}

resource "aws_autoscaling_group" "borough-market-autoscaling" {
  name                = "${var.AWS_RESOURCE_PREFIX}-ecs-autoscaling"
  vpc_zone_identifier = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id, aws_subnet.main-public-3.id]

  min_size                  = "1"
  max_size                  = "10"
  desired_capacity          = "1"
  launch_configuration      = aws_launch_configuration.borough-market.name
  health_check_grace_period = 120
  default_cooldown          = 30
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "ECS-EC2-container"
    propagate_at_launch = true
  }
}



resource "aws_autoscaling_policy" "borough-market-autoscaling-policy" {
  name                      = "${var.AWS_RESOURCE_PREFIX}-ecs-autoscaling-policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = aws_autoscaling_group.borough-market-autoscaling.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}


resource "aws_launch_configuration" "borough-market" {
  name_prefix     = "${var.AWS_RESOURCE_PREFIX}-launch-configuration"
  security_groups = [aws_security_group.instance-sg.id]

  image_id                    = var.ECS_AMI
  instance_type               = var.INSTANCE_TYPE
  iam_instance_profile        = aws_iam_instance_profile.ecs-ec2-role.id
  user_data                   = "#!/bin/bash\necho 'ECS_CLUSTER=borough-market-cluster' >> /etc/ecs/ecs.config"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}
