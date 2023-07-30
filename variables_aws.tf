variable "aws_region" {
    type = string
    default = "eu-central-1"  
}

#variable "ecr_name" {
#    type = string
#    default = "test_ecr_reg"  
#}

variable "ecr_untagged_images_count" {
    type = string
    default = "3"  
}

variable "ecs_cluster_name" {
    type = string
    default = "test_ecs_cluster"
}

variable "ecs_service_name" {
    type = string
    default = "test_ecs_service"
}

variable "task_port" {
    type = string
    default = "5000"
}

