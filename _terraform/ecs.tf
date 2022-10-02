resource "aws_ecs_cluster" "borough-market" {
  name = local.aws_ecs_cluster_name
}


resource "aws_launch_configuration" "borough-market-launchconfig" {
  name_prefix          = "${var.AWS_RESOURCE_PREFIX}-ecs-launchconfig"
  image_id             = var.ECS_AMIS
  instance_type        = var.ECS_INSTANCE_TYPE
  key_name             = aws_key_pair.mykeypair.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs-ec2-role.id
  security_groups      = [aws_security_group.ecs-securitygroup.id]

  # https://docs.aws.amazon.com/ko_kr/AmazonECS/latest/developerguide/launch_container_instance.html
  user_data = "#!/bin/bash\necho 'ECS_CLUSTER=borough-market-cluster' > /etc/ecs/ecs.config\nstart ecs"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "borough-market-autoscaling" {
  name_prefix          = "${var.AWS_RESOURCE_PREFIX}-ecs-autoscaling"
  vpc_zone_identifier  = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  launch_configuration = aws_launch_configuration.borough-market-launchconfig.name

  min_size = 1
  max_size = 6

  tag {
    key                 = "Name"
    value               = "ecs-ec2-container"
    propagate_at_launch = true
  }
}
