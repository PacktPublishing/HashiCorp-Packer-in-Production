variable "IMG_VERSION"{
  default = "1.0"
}

source "docker" "base_ubuntu" {
  image = "library/fedora:latest"
  
  // Export or commit to local images
  export_path = "image.tar"
  #commit = true

  #run_command = ["/usr/bin/nginx", "-d", "daemon", "off;"]

  platform = "linux/amd64"
}

build {
  sources = [
    "source.docker.base_ubuntu"
  ]

  provisioner "shell" {
    inline = ["cat /etc/os-release"]
  }

  post-processor "shell-local" {
    inline = ["pzstd --force ./*.tar"]
  }

  // post-processors {
  //  post-processor "docker-tag" {
      // Use the DOCKER_REGISTRY from common.hcl
  //    repository =  "${var.DOCKER_REGISTRY}/${source.name}"
  //    tags = [var.IMG_VERSION]
  //  }
  //  post-processor "docker-push" {}
  //}
}
