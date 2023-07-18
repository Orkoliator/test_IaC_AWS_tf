terraform {
  required_providers {
    docker = {
      source  = "registry.terraform.io/kreuzwerker/docker"
      version = ">=3.0.2"
    }
  }
}

provider "docker" {
  host = var.docker_host
  registry_auth {
    address  = "${var.ecr_url}"
    username = "someuser"
    password = "somepass"
  }
}