
module "aws_ecr" {
  source = "./AWS_ECR"
  aws_region = var.aws_region
  ecr_name = var.ecr_name
}

module "docker_image" {
  source = "./docker"
  docker_host = var.docker_host
  docker_image_url = var.docker_image_url
  docker_image_name = var.docker_image_name
  docker_image_author = var.docker_image_author
  docker_image_tag = var.docker_image_tag
  ecr_url = "${module.aws_ecr.ecr_url}"
  ecr_username = "${module.aws_ecr.ecr_username}"
  ecr_password = "${module.aws_ecr.ecr_password}"
}

module "aws_application" {
  source = "./AWS_APP"
  aws_region = var.aws_region
  ecs_cluster_name = var.ecs_cluster_name
  ecs_service_name = var.ecs_service_name
  ecr_url = "${module.aws_ecr.ecr_url}"
  container_image_name = "${module.docker_image.container_image_name}"
  task_port = var.task_port
}
