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

data "aws_iam_policy" "test_ecr_read_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "test_ecs_task_execution_role" {
  role       = aws_iam_role.test_ecs_task_execution_role.name
  policy_arn = data.aws_iam_policy.test_ecs_task_execution_role.arn
}

resource "aws_iam_role_policy_attachment" "test_ecs_task_execution_role" {
  role       = aws_iam_role.test_ecs_task_execution_role.name
  policy_arn = data.aws_iam_policy.test_ecr_read_role.arn
}

