resource "aws_lb_target_group" "test_api" {
  name        = "${var.ecs_service_name}-${var.aws_region}-api"
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
  name               = "${var.ecs_service_name}-${var.aws_region}-api-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public.id,
    aws_subnet.public.id,
  ]

  security_groups = [
    aws_security_group.egress_all.id,
  ]

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_alb_listener" "test_api_http" {
  load_balancer_arn = aws_alb.test_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_lb.arn
  }
}

output "alb_url" {
  value = "http://${aws_alb.test_lb.dns_name}"
}