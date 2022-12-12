// A sample Packer template to demonstrate the manifest post processor.
// Variant of Chapter08/Docker example.
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

  post-processors {
    post-processor "manifest" {}
  }
}
