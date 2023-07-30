resource "aws_ecs_cluster" "test-ecs-cluster" {
  name = "${var.ecs_cluster_name}-${var.aws_region}"
}

resource "aws_ecs_service" "test-ecs-service-two" {
  name = "${var.ecs_service_name}-${var.aws_region}-app"
  cluster = aws_ecs_cluster.test-ecs-cluster.id
  task_definition = aws_ecs_task_definition.test-ecs-task-definition.arn
  desired_count = 1
}

resource "aws_ecs_task_definition" "test-ecs-task-definition" {
  family = "service"
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
}