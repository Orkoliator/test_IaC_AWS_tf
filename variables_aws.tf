variable "aws_region" {
    type = string
    default = "eu-central-1"  
}

variable "ecr_name" {
    type = string
    default = "test_ecr_reg"  
}

variable "ecs_name" {
    type = string
    default = "test_ecs_repo"
}