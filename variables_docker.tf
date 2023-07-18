variable "docker_host" {
    type = string
    default = "tcp://host.docker.internal:2375/"
}

variable "docker_image_url" {
    type = string
    default = "https://github.com/bbachi/python-flask-restapi.git"
}

variable "docker_image_name" {
    type = string
    default = "test-api"
}

variable "docker_image_author" {
    type = string
    default = "bbachi"
}

variable "docker_image_tag" {
    type = string
    default = "api:test"
}
