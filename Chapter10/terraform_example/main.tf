// John Boero - HashiCorp Packer in Production
// A sample of Terraform to look up AMI IDs from HCP channels.
// Revoking the parent image will automatically revoke this child.

// Since we're going to look up more than one image select the iteration.
data "hcp_packer_image_iteration" "gpu-test" { 
  bucket_name = "al-gpu"
  channel     = "test"
}

// Look up the ARM GPU AMI ID for test iteration.
data "hcp_packer_image" "ami-arm-gpu" {
  bucket_name    = "al-gpu"
  cloud_provider = "aws"
  region         = "eu-west-1"

  // Specify channel here or the iteration selected above.
  #channel        = "test"
  iteration_id = data.hcp_packer_image_iteration.gpu-test.id

  // Use component_type to select precise image/architecture.
  // If you don't specify you may get the wrong image.
  #component_type = "amazon-ebs.al-x86_64-gpu"
  component_type = "amazon-ebs.al-aarch64-gpu"
}

// Just output the AMI
output "amiid_aarch64" {
    value = data.hcp_packer_image.ami-arm-gpu.cloud_image_id
}


// Look up the ARM GPU AMI ID for test iteration.
data "hcp_packer_image" "ami-x86_64-gpu" {
  bucket_name    = "al-gpu"
  cloud_provider = "aws"
  region         = "eu-west-1"

  // Specify channel here or the iteration selected above.
  #channel        = "test"
  iteration_id = data.hcp_packer_image_iteration.gpu-test.id

  // Use component_type to select precise image/architecture.
  // If you don't specify you may get the wrong image.
  #component_type = "amazon-ebs.al-x86_64-gpu"
  component_type = "amazon-ebs.al-x86_64-gpu"
}

// Just output the AMI.
output "amiid_x86_64" {
    value = data.hcp_packer_image.ami-x86_64-gpu.cloud_image_id
}

// Provisioning an ec2 instance is simple now.
// If your AWS creds have default VPC, region this is minimal.
/** /
resource "aws_instance" "gpu-test" {
  ami           = data.hcp_packer_image.ami-x86_64-gpu.cloud_image_id
  instance_type = "t3.micro"
}
/**/