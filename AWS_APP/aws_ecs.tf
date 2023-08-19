resource "aws_ecs_cluster" "test_ecs_cluster" {
  name = "${var.ecs_cluster_name}-${var.aws_region}"
}

resource "aws_ecs_service" "test_ecs_service" {
  name = "${var.ecs_service_name}-${var.aws_region}-app"
  cluster = aws_ecs_cluster.test_ecs_cluster.id
  task_definition = aws_ecs_task_definition.test_ecs_task_definition.arn
  launch_type = "FARGATE"
  force_new_deployment = true

  network_configuration {
    assign_public_ip = true

    security_groups = [
      aws_security_group.egress_all.id,
      aws_security_group.ingress_api.id,
    ]

    subnets = [
      aws_subnet.private.id,
    ]
  }

  desired_count = 1
}

resource "aws_ecs_task_definition" "test_ecs_task_definition" {
  family = "service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory             = 1024
  cpu                = 512
  task_role_arn            = "${aws_iam_role.test_iam_role.arn}"
  execution_role_arn       = "${resource.aws_iam_role.test_ecs_task_execution_role.arn}"
  container_definitions    = <<EOF
[
  {
    "name": "${var.ecs_service_name}-${var.aws_region}-app",
    "image": "${var.ecr_url}:latest",
    "portMappings": [
      {
        "containerPort": ${var.task_port},
        "hostPort": ${var.task_port}
      }
    ]
  }
]
EOF
runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}