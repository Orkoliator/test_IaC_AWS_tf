resource "docker_image" "test_docker_image" {
  name = "${var.docker_image_name}-${var.docker_image_author}"
  build {
    context = "${var.docker_image_url}"
    tag     = ["${var.docker_image_tag}"]
    label = {
      author : "${var.docker_image_author}"
    }
  }
}

resource "docker_registry_image" "media-handler" {
  name = docker_image.test_docker_image.name
}