resource "aws_ecr_repository" "ecr_reg" {
  name = "${var.ecr_name}-${var.aws_region}"
#  name = "${var.docker_image_name}-${var.docker_image_author}"
  image_scanning_configuration {
	    scan_on_push = true
	  }
}

resource "aws_ecr_lifecycle_policy" "default_policy" {
  repository = aws_ecr_repository.ecr_reg.name
	  policy = <<EOF
	{
	    "rules": [
	        {
	            "rulePriority": 1,
	            "description": "Keep only the last ${var.ecr_untagged_images_count} untagged images.",
	            "selection": {
	                "tagStatus": "untagged",
	                "countType": "imageCountMoreThan",
	                "countNumber": ${var.ecr_untagged_images_count}
	            },
	            "action": {
	                "type": "expire"
	            }
	        }
	    ]
	}
	EOF
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