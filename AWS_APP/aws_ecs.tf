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
    assign_public_ip = false

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

data "aws_iam_policy_document" "test_ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "test_ecs_task_execution_role" {
  name = "ecs-task-execution-role"
  assume_role_policy = "${data.aws_iam_policy_document.test_ecs_tasks_execution_role.json}"
}

resource "aws_iam_role" "test_iam_role" {
  name = "${var.ecs_service_name}-${var.aws_region}-iam"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
            "Service": [
                "s3.amazonaws.com",
                "ecr.amazonaws.com",
                "lambda.amazonaws.com",
                "ecs.amazonaws.com"
            ]
            },
            "Effect": "Allow",
            "Sid": ""
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ecs-tasks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

data "aws_iam_policy" "test_ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "test_ecs_task_execution_role" {
  role       = aws_iam_role.test_ecs_task_execution_role.name
  policy_arn = data.aws_iam_policy.test_ecs_task_execution_role.arn
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