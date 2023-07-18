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
    "image": "${var.ecr_url}/${var.container_image_name}:latest",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
EOF
}