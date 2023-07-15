resource "docker_image" "docker_image" {
  name = "${var.docker_image_name}-${var.docker_image_author}"
  build {
    context = "${var.docker_image_url}"
    tag     = ["${var.docker_image_tag}"]
    label = {
      author : "${var.docker_image_author}"
    }
  }
}