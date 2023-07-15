
module "aws" {
  source = "./AWS"
  aws_region = var.aws_region
  ecr_name = var.ecr_name
  ecs_name = var.ecs_name
}

module "docker" {
  source = "./docker"
  host = "tcp://127.0.0.1:2375/"
  docker_image_url = var.docker_image_url
  docker_image_name = var.docker_image_name
  docker_image_author = var.docker_image_author
  docker_image_tag = var.docker_image_tag
}