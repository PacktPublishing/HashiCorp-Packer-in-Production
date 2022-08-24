# A Packer template to build a RHEL9 base image in AWS.
# Relies on common.pkr.hcl for variables and AWS credentials.

data "amazon-ami" "base-el9" {
  filters = {
    name                = "base_rhel9"
  }
  most_recent = true
}

// Use SSH agent authentication
source "amazon-ebs" "kubernetes_rhel9" {
  ami_name      = "kubernetes_rhel9"
  communicator  = "ssh"
  instance_type = "t2.micro"
  source_ami    = data.amazon-ami.base-el9.id // From base
  ssh_username  = "root"
  deprecate_at  = timeadd(timestamp(), "240h")
  ami_regions   = var.AWS_REGIONS
}

build {
  sources = [
    "source.amazon-ebs.kubernetes_rhel9"
    ]
    
    // For base image make sure we are up to date.
    // Also install OpenSCAP, do a scan for PCI-DSS compliance,
    // And download the result report locally.
    provisioner "shell" {
      inline = [
        "dnf install kubelet",
        "systemctl enable kubelet.service"
      ]
    }

    provisioner "file" {
      destination = "/etc/kubelet/kubelet.conf"
      content =<<EOF
      # Example kubernetes config.
      EOF
    }
  }
