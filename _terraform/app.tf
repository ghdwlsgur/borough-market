
resource "aws_ecs_task_definition" "task-definition" {
  family = var.AWS_RESOURCE_PREFIX

  container_definitions = templatefile("templates/app.json.tpl", {
    REPOSITORY_URL = replace(aws_ecr_repository.borough-market.repository_url, "https://", "")
    APP_VERSION    = var.VERSION
  })
}

resource "aws_ecs_service" "app-service" {
  count = var.SERVICE_ENABLE
  # 수정
  # name  = var.AWS_RESOURCE_PREFIX
  name = local.aws_ecs_service_name

  cluster         = aws_ecs_cluster.borough-market.id
  task_definition = aws_ecs_task_definition.task-definition.arn
  desired_count   = 1

  iam_role   = aws_iam_role.ecs-service-role.arn
  depends_on = [aws_iam_policy_attachment.ecs-service-attach1]

  load_balancer {
    elb_name       = aws_elb.app-elb.name
    container_name = var.AWS_RESOURCE_PREFIX
    container_port = 3000
  }

  lifecycle {
    ignore_changes = [task_definition]
  }

}

resource "aws_elb" "app-elb" {
  name = "${var.AWS_RESOURCE_PREFIX}-elb"

  listener {
    instance_port     = 3000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    target              = "HTTP:3000/"
    interval            = 60
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  subnets         = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  security_groups = [aws_security_group.elb-securitygroup.id]

  tags = {
    Name = "${var.AWS_RESOURCE_PREFIX}-elb"
  }
}
