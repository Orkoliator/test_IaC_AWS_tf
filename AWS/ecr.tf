resource "aws_ecr_repository" "ecr_reg" {
  name = "${var.ecr_name}-${var.aws_region}"
  image_scanning_configuration {
	    scan_on_push = true
	  }
}