# A Packer template to build a RHEL9 base image in AWS.
# Relies on common.pkr.hcl for variables and AWS credentials.

data "amazon-ami" "el9-amd64" {
  filters = {
    name                = "RHEL-9*x86_64*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["309956199498"]

  /** /
  # Optional assume_role for data sources.
  assume_role {
    role_arn     = "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
    session_name = "SESSION_NAME"
    external_id  = "EXTERNAL_ID"
  }
  /**/
}

// Use SSH agent authentication
source "amazon-ebs" "base_rhel9" {
  ami_name      = "base_rhel9"
  communicator  = "ssh"
  instance_type = "t2.micro"
  source_ami    = data.amazon-ami.el9-amd64.id
  ssh_username  = "root"
  deprecate_at  = timeadd(timestamp(), "240h")
  ami_regions   = var.AWS_REGIONS
}

build {
  sources = [
    "source.amazon-ebs.base_rhel9"
    ]
    
    // For base image make sure we are up to date.
    // Also install OpenSCAP, do a scan for PCI-DSS compliance,
    // And download the result report locally.
    provisioner "shell" {
      inline = [
        "dnf update -y",
        "dnf install openscap openscap-utils"
        "oscap xccdf eval --report /root/scap_report.html --profile ospp /usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml"
      ]
    }

    // Download and archive the SCAP scan result.
    provisioner "file" {
      source = "/root/scap_report.html"
      destination = "/home/${USER}/packer_artifacts/base_scap_${build.ID}.html"
      direction = "download"
    }
  }
