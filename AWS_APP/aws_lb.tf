resource "aws_lb_target_group" "test_api" {
  name        = "test-api" # no var because underlines are not supported
  port        = var.task_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.app_vpc.id

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.test_lb]
}

resource "aws_alb" "test_lb" {
  name               = "test-api-lb" # no var because underlines are not supported
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
  ]

  security_groups = [
    aws_security_group.lb_group.id,
  ]

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_alb_listener" "test_api_http" {
  load_balancer_arn = aws_alb.test_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_api.arn
  }
}

output "alb_url" {
  value = "http://${aws_alb.test_lb.dns_name}"
}


resource "aws_security_group" "lb_group" {
  name        = "egress-all"
  description = "Allow all outbound traffic"
  vpc_id      = aws_vpc.app_vpc.id
}

resource "aws_security_group_rule" "lb_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_group.id
}

resource "aws_security_group_rule" "lb_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_group.id
}