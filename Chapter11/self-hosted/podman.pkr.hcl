packer {
  required_plugins {
    podman = {
      version = ">=v0.1.0"
      source  = "github.com/Polpetta/podman"
    }
  }
}

source "podman" "base_ubuntu" {
  image = "ubuntu:latest"
  
  // Export or commit to local images
  export_path = "image.tar"
  #commit = true

  #run_command = ["/usr/bin/nginx", "-d", "daemon", "off;"]
  
  # Platform(s) is actually not yet supported in the Podman plugin.
  platforms = ["amd64","arm64","riscv"]
}

build {
  sources = [
    "source.podman.base_ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "apt install -y nginx git",
      "cd /usr/share/nginx/html/",
      "git clone https://github.com/jboero/hashibo.git"
    ]
  }

  /** /
  // Optionally compress all image exports with parallel zstd.
  post-processor "shell-local" {
    inline = ["pzstd ./*.tar"]
  }
  /**/
}
