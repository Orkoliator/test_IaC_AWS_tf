variable "aws_region" {
    type = string
}

variable "ecr_url" {
    type = string
}

variable "ecs_cluster_name" {
    type = string
}

variable "ecs_service_name" {
    type = string
}

variable "task_port" {
    type = string
}

variable "vpc_cidr_block" {
    type = string
}

variable "subnet_public_cidr_block" {
    type = string
}

variable "subnet_private_cidr_block" {
    type = string
}