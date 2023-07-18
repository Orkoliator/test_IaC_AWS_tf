resource "aws_ecr_repository" "ecr_reg" {
  name = "${var.ecr_name}-${var.aws_region}"
  image_scanning_configuration {
	    scan_on_push = true
	  }
}

output "ecr_url" {
  value = aws_ecr_repository.ecr_reg.repository_url
}