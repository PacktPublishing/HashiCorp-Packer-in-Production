// Extend our Amazon Linux base image for GPU workloads.
// Use the al-latest bucket as ancestor.
// We'll enable Graviton aarch64 to save some costs over x86_64.
// Use HCP Packer's latest channel to always consume the latest version of the image published to the bucket that hasn't been revoked or had its parent revoked

// Ancestry requires a recent version of the AWS plugin.
packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

// We're going to need HCP bucket often, so make it a variable.
variable "hcp_bucket" {
  default = "latest-al"
}

variable "region" {
  default = "eu-west-1"
}

// By default use latest channel
// The latest channel is autumatically managed by HCP Packer to always be pointing at the newest unrevoked iteration
// You can also use a user created channel
variable "channel" {
  default = "latest"
}

// Set the nvidia driver version.
variable "nvidia_version" {
  default = "525.60.13"
}

// Look up the test iteration from our bucket.
// Iteration can be used or we can specify a channel in the data source below.
/** /
data "hcp-packer-iteration" "latest_al" {
  bucket_name = var.hcp_bucket
  channel = var.channel
}
/**/

// Look up the aarch64 image within the test iteration.
data "hcp-packer-image" "al_latest_aarch64" {
    bucket_name     = var.hcp_bucket
    channel         = var.channel
    cloud_provider  = "aws"
    component_type  = "amazon-ebs.al-aarch64-latest"
    region          = var.region
}

// Look up the x86_64 image within the test iteration.
data "hcp-packer-image" "al_latest_x86_64" {
    bucket_name     = var.hcp_bucket

    channel         = var.channel

    cloud_provider  = "aws"
    component_type  = "amazon-ebs.al-x86_64-latest"
    region          = var.region
}

// Create a specific source with Graviton GPU instance.
// This does not translate well to reference sources.
source "amazon-ebs" "al-aarch64-gpu" {
  source_ami = data.hcp-packer-image.al_latest_aarch64.id
  region     = var.region

  shutdown_behavior = "terminate"
  force_deregister = true
  force_delete_snapshot = true
  ssh_username = "ec2-user"

  ami_name = "al-aarch64-gpu-${var.channel}"

  // Build with Graviton g5g.xlarge intances.
  // The smallest Graviton instance with NVidia GPUs.
  #instance_type = "g3g.xlarge"

  // Note you can install Nvidia drivers in an instance without a GPU
  // The installer just needs a newline on stdin to bypass a warning.
  instance_type = "t4g.small"
}

// Build the same image for x86_64 also.
source "amazon-ebs" "al-x86_64-gpu" {
  source_ami = data.hcp-packer-image.al_latest_x86_64.id
  region     = var.region

  shutdown_behavior = "terminate"
  force_deregister = true
  force_delete_snapshot = true
  ssh_username = "ec2-user"

  ami_name = "al-x86_64-gpu-${var.channel}"

  // Build with Xeon GPU g5.xlarge intances.
  #instance_type = "g3s.xlarge"

  // Note you can install Nvidia drivers in an instance without a GPU
  // The installer just needs a newline on stdin to bypass a warning.
  instance_type = "t2.small"
}

build {
  name    = "al-gpu"

  // Build for aarch64 and x86_64 GPU instances
  sources = [
    "source.amazon-ebs.al-x86_64-gpu",
    "source.amazon-ebs.al-aarch64-gpu"
  ]

  hcp_packer_registry {
    description = "Graviton GPU AL image built from AL ancestor"

    // This is a NEW bucket name. Don't re-use the ancestor name.
    bucket_name = "al-gpu"

    bucket_labels = {
        "team" = "multimedia",
        "os"   = "Amazon Linux"
        "gpu"  = "NVIDIA A10G"
    }

    build_labels = {
        "distro" = "AL",
        "build-time" = timestamp()
    }
  }

  // Sudo/root access to root content as ec2-user can be a pain.
  // Here we append a line to the MOTD to warn users about latest release.
  provisioner "shell" {
    // Nvidia installer shows menu warning even when ui is disabled with no GPU
    // Feed a cheeky echo newline to the installer stdin to bypass this ugly.
    inline = [<<EOF
    sudo sh -c "yum install -y gcc kernel-devel ncurses clinfo vulkan"
    curl -o nvidia.run https://us.download.nvidia.com/tesla/525.60.13/NVIDIA-Linux-$(uname -m)-${var.nvidia_version}.run
    chmod +x nvidia.run
    sudo sh -c "echo | ./nvidia.run --ui=none -s -q -a"
    EOF
    ]
  }

  // Add your provisioners here..
}
