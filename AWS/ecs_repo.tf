resource "aws_ecr_repository" "ecr_repo" {
  name = "${var.ecs_name}-${var.aws_region}"
}
