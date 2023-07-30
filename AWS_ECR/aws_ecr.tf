resource "aws_ecr_repository" "ecr_reg" {
  name = "${var.docker_image_name}-${var.docker_image_author}"
  image_scanning_configuration {
	    scan_on_push = true
	  }
  force_delete = true
}

resource "aws_ecr_repository_policy" "demo-repo-policy" {
  repository = aws_ecr_repository.ecr_reg.name
  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the demo repository",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
  EOF
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

output "ecr_proxy_endpoint" {
  value = data.aws_ecr_authorization_token.token.proxy_endpoint
}

output "ecr_url" {
  value = aws_ecr_repository.ecr_reg.repository_url
}

output "ecr_username" {
  value = data.aws_ecr_authorization_token.token.user_name
}

output "ecr_password" {
  value = data.aws_ecr_authorization_token.token.password
}