resource "aws_ecr_repository" "ecr_reg" {
  name = "${var.ecr_name}-${var.aws_region}"
  image_scanning_configuration {
	    scan_on_push = true
	  }
}

data "aws_ecr_authorization_token" "token" {}

output "ecr_url" {
  value = aws_ecr_repository.ecr_reg.repository_url
}

output "ecr_username" {
  value = data.aws_ecr_authorization_token.token.user_name
}

output "ecr_password" {
  value = data.aws_ecr_authorization_token.token.password
}