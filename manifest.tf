module "dev-webserver" {
  source = "./AWS"
  aws_region = var.aws_region
  ecs_name = var.ecs_name
}