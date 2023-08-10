variable "aws_region" {
    type = string
    default = "eu-central-1"  
}

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

variable "aws_availability_zone" {
    type = string
    default = "eu-central-1a"  
}

variable "vpc_cidr_block" {
    type = string
    default = "192.168.0.0/16"
}

variable "subnet_public_cidr_block" {
    type = string
    default = "192.168.1.0/24"
}

variable "subnet_private_cidr_block" {
    type = string
    default = "192.168.2.0/24"
}