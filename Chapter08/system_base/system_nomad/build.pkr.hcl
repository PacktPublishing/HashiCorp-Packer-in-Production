# A Packer template to build a RHEL9 base image in AWS.
# Relies on common.pkr.hcl for variables and AWS credentials.

data "amazon-ami" "el9-amd64" {
  filters = {
    name                = "base_rhel9*"
  }
  most_recent = true
}

// Use SSH agent authentication
source "amazon-ebs" "nomad_rhel9" {
  ami_name      = "nomad_rhel9"
  communicator  = "ssh"
  instance_type = "t2.micro"
  source_ami    = data.amazon-ami.el9-amd64.id
  ssh_username  = "root"
  deprecate_at  = timeadd(timestamp(), "240h")
  ami_regions   = var.AWS_REGIONS
}

build {
  sources = [
    "source.amazon-ebs.nomad_rhel9"
    ]
    
    // For base image make sure we are up to date.
    // Also install OpenSCAP, do a scan for PCI-DSS compliance,
    // And download the result report locally.
    provisioner "shell" {
      inline = [
        // Enable HashiCorp Repo and install Nomad.
        "dnf install nomad"
      ]
    }

    // Download and archive the SCAP scan result.
    provisioner "file" {
      content =<<EOF
      #  Sample Nomad config.
      EOF
      destination = "/etc/nomad.d/nomad.hcl"
    }
  }
