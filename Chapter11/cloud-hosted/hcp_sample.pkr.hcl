// Define base images for Amazon Linux latest on x86_64 and arm64 (Graviton)
// Skip source_ami_filter for references in the build block.
source "amazon-ebs" "al-latest" {
  ami_name = source.name
  region   = "eu-west-1"

  shutdown_behavior = "terminate"
  #force_deregister = true
  #force_delete_snapshot = true
  ssh_username = "ec2-user"
}

build {
  name    = "Base images for Amazon Linux cross architecture"

  // One reference instance for arm64
  source "amazon-ebs.al-latest" {
    name = "al-aarch64-latest"
    instance_type = "c6g.medium"
    source_ami_filter {
      filters = {
        name      = "*64bit_arm-eb_ecs_amazon_linux_2-hvm*"
      }
      most_recent = true
      owners      = ["amazon"]
    }
  }

  // One reference instance for x86_64
  source "amazon-ebs.al-latest" {
    name = "al-x86_64-latest"
    instance_type = "t2.small"
    source_ami_filter {
      filters = {
        name = "*64bit-eb_ecs_amazon_linux_2-hvm*"
      }
      most_recent = true
      owners      = ["amazon"]
    }
  }

  hcp_packer_registry {
    description = "test"

    # The HCP bucket name (not AWS bucket name) for this build.
    # This will reflect in HCP Packer as "image name"
    bucket_name = "latest-al"

    bucket_labels = {
        "team" = "packer",
        "os"   = "Amazon Linux"
    }

    build_labels = {
        "distro" = "AL",
        "build-time" = timestamp()
    }
  }

  // Sudo/root access to root content as ec2-user can be a pain.
  // Here we append a line to the MOTD to warn users about latest release.
  provisioner "shell" {
    inline = [<<EOF
      uname -a
      cat /etc/os-release
      sudo sh -c "echo EXPERIMENTAL SOFTWARE Use for testing only. >> /etc/motd"
      sudo sh -c "yum update -y"
      EOF
    ]
  }

  // Add your provisioners here..
}
