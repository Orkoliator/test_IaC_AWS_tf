variable "aws_region" {
    type = string
    default = "eu-central-1"  
}

provider "aws" {
    region = var.aws_region
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}