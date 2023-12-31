
module "aws_ecr" {
  source = "./AWS_ECR"
  aws_ecs_region = var.aws_ecs_region
  ecr_untagged_images_count = var.ecr_untagged_images_count
  docker_image_name = var.docker_image_name
  docker_image_author = var.docker_image_author
}

module "docker_image" {
  source = "./docker"
  docker_host = var.docker_host
  docker_image_name = var.docker_image_name
  docker_image_author = var.docker_image_author
  docker_image_tag = var.docker_image_tag
  ecr_proxy_endpoint = "${module.aws_ecr.ecr_proxy_endpoint}"
  ecr_url = "${module.aws_ecr.ecr_url}"
  ecr_username = "${module.aws_ecr.ecr_username}"
  ecr_password = "${module.aws_ecr.ecr_password}"
  git_user = var.git_user
  git_repo = var.git_repo
}

module "aws_ecs_application" {
  source = "./AWS_ecs_app"
  aws_ecs_region = var.aws_ecs_region
  ecs_cluster_name = var.ecs_cluster_name
  ecs_service_name = var.ecs_service_name
  ecr_url = "${module.aws_ecr.ecr_url}"
  task_port = var.task_port
  aws_availability_zone_a = var.aws_availability_zone_a
  aws_availability_zone_b = var.aws_availability_zone_b
  vpc_cidr_block = var.vpc_cidr_block
  subnet_public_a_cidr_block = var.subnet_public_a_cidr_block
  subnet_public_b_cidr_block = var.subnet_public_b_cidr_block
  subnet_private_a_cidr_block = var.subnet_private_a_cidr_block
  subnet_private_b_cidr_block = var.subnet_private_b_cidr_block
}

module "aws_lambda_application" {
  source = "./AWS_lambda_app"
  aws_lambda_region = var.aws_lambda_region
  lambda_name = var.lambda_name
  stage_name = var.stage_name
  url = var.url
}
