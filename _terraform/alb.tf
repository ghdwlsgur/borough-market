resource "aws_alb" "borough-market-alb" {
  name            = "${var.AWS_RESOURCE_PREFIX}-alb"
  subnets         = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id, aws_subnet.main-public-3.id]
  security_groups = [aws_security_group.alb-sg.id]
  enable_http2    = "true"
  idle_timeout    = 300
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.borough-market-alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.nginx.id
    type             = "forward"
  }
}


resource "aws_alb_target_group" "nginx" {
  name       = "nginx"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.main.id
  depends_on = [aws_alb.borough-market-alb]

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
  }

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}
