resource "aws_security_group" "ecs-securitygroup" {
  vpc_id      = aws_vpc.main.id
  name        = "ecs-sg"
  description = "security group for ECS"

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.elb-securitygroup.id]
  }

  tags = {
    Name = "ecs-sg"
  }
}


resource "aws_security_group_rule" "ecs-inbound-22" {
  type              = "ingress"
  description       = "Allow 22 port from anywhere"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs-securitygroup.id
}

resource "aws_security_group_rule" "ecs-outbound" {
  type              = "egress"
  description       = "Allow to anywhere"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs-securitygroup.id
}

resource "aws_security_group" "elb-securitygroup" {
  vpc_id      = aws_vpc.main.id
  name        = "elb-sg"
  description = "security group for elb"

  tags = {
    Name = "elb-sg"
  }
}

resource "aws_security_group_rule" "elb-inbound-80" {
  type              = "ingress"
  description       = "Allow http port from anywhere"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elb-securitygroup.id
}

resource "aws_security_group_rule" "elb-outbound" {
  type              = "egress"
  description       = "Allow to anywhere"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elb-securitygroup.id
}
