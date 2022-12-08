// A sample Packer template to cross-build base container images for the latest Ubuntu.
// Platforms include x86_64/amd64, aarch64/arm64, and riscv64
// Requires qemu-static-x86_64, qemu-static-aarch64, and qemu-static-riscv64 installe.d
// Author: John Boero for Packer in Production
variable "IMG_VERSION"{
  default = "1.0"
}

source "docker" "base_ubuntu" {
  image = "library/ubuntu:latest"
  
  // Export or commit to local images
  export_path = "${source.name}.tar"
  #commit = true

  #run_command = ["/usr/bin/nginx", "-d", "daemon", "off;"]

  // Set this in each invocation
  #platform = "linux/amd64"
}

build {
  // Skip the sources list this time for custom source overrides
  #sources = ["source.docker.base_ubuntu"]

  // This dynamic HCL2 creates 3 sources inline based on the "source.docker.base_ubuntu" above.
  // It fills each dynamic source with names and platforms from the for_each set.
  // Note that Packer does not seem to support the toset() function.
  // The result of this block is fully displayed in comment below.
  dynamic "source" {
    for_each = {arch="x86_64",arch="aarch64",arch="riscv64"}
    labels = ["source.docker.base_ubuntu"]

    content {
      name = source.value
      platform = "linux/${source.value}"
    }
  }
  
  /*
  // This example is what the above dynamic code generates.
  source "source.docker.base_ubuntu"{
    name = "x86_64"
    platform = "linux/x86_64"
  }
  
  source "source.docker.base_ubuntu"{
    name = "aarch64"
    platform = "linux/aarch64"
  }

  source "source.docker.base_ubuntu"{
    name = "riscv64"
    platform = "linux/riscv64"
  }*/

  provisioner "shell" {
    inline = ["cat /etc/os-release"]
  }

  post-processor "shell-local" {
    inline = ["pzstd -f ${source.name}.tar"]
  }

  post-processors {
    post-processor "docker-tag" {
      // Use the DOCKER_REGISTRY from common.hcl
      repository =  "${var.DOCKER_REGISTRY}/${source.name}"
      tags = [var.IMG_VERSION]
    }
    post-processor "docker-push" {}
  }
}
