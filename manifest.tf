module "dev-webserver" {
  source = "./AWS"
  aws_region = var.aws_region
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  ecs_name = var.ecs_name
}