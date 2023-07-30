resource "local_file" "dir" {
  content  = "hello there"
  filename = "./repo/placeholder.txt"
}

resource "null_resource" "git_pull" {
  provisioner "local-exec" {
    command = "git init && git pull https://github.com/${var.git_user}/${var.git_repo}.git"
    working_dir = "./repo/"
  }
  depends_on = [ local_file.dir ]
}

resource "docker_image" "test_docker_image" {
  name = "${var.ecr_url}"
  build {
    context = "./repo/"
#    tag     = [ "${var.ecr_url}:latest", "${var.ecr_url}:${var.docker_image_tag}"]
    tag     = [ "${var.ecr_url}:latest" ]
    label = {
      author : "${var.docker_image_author}"
    }
  }
  depends_on = [ null_resource.git_pull ]
}

resource "docker_registry_image" "registry" {
  name = "${var.ecr_url}"
}

output "container_image_name" {
  value = docker_registry_image.registry.name
}
