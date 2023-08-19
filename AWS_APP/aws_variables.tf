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

variable "aws_availability_zone_a" {
    type = string
}

variable "aws_availability_zone_b" {
    type = string
}

variable "vpc_cidr_block" {
    type = string
}

variable "subnet_public_a_cidr_block" {
    type = string
}

variable "subnet_public_b_cidr_block" {
    type = string
}

variable "subnet_private_a_cidr_block" {
    type = string
}

variable "subnet_private_b_cidr_block" {
    type = string
}