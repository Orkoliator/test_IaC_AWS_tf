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

variable "aws_availability_zone_a" {
    type = string
    default = "eu-central-1a"
}

variable "aws_availability_zone_b" {
    type = string
    default = "eu-central-1c"
}

variable "vpc_cidr_block" {
    type = string
    default = "192.168.0.0/16"
}

variable "subnet_public_a_cidr_block" {
    type = string
    default = "192.168.1.0/25"
}

variable "subnet_public_b_cidr_block" {
    type = string
    default = "192.168.1.128/25"
}

variable "subnet_private_a_cidr_block" {
    type = string
    default = "192.168.2.0/25"
}

variable "subnet_private_b_cidr_block" {
    type = string
    default = "192.168.2.128/25"
}