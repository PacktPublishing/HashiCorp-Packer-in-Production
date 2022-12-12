// A sample Packer template to cross-build base container images for the latest Ubuntu.
// Platforms include x86_64/amd64, aarch64/arm64, and riscv64
// Requires qemu-static-x86_64, qemu-static-aarch64, and qemu-static-riscv64 installe.d
// Author: John Boero for Packer in Production
source "docker" "base_ubuntu" {
  image = "library/ubuntu:latest"
  export_path = "${source.name}.tar"
}

build {
  dynamic "source" {
    for_each = {arch="x86_64",arch="aarch64",arch="riscv64"}
    labels = ["source.docker.base_ubuntu"]

    content {
      name = source.value
      platform = "linux/${source.value}"
    }
  }

  post-processor "shell-local" {
    inline = ["pzstd -f ${source.name}.tar"]
  }

  post-processors {
    post-processor "docker-tag" {
      repository =  "testing/${source.name}"
    }
    post-processor "docker-push" {}
  }
}
