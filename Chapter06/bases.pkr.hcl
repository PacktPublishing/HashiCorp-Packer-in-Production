/*  A HCL2 Sample Packer manifest.
    John Boero   */
// HCL2 extrapolates builders as "sources"
packer {
  required_version = ">= 1.8.0"
}

locals {
//  vsphere_user  = vault("/secret/data/vsphere/creds", "user")
//  vsphere_pw    = vault("/secret/data/vsphere/creds", "password")
  rootpw        = uuidv4()
}

// Parameterize the CentOS Streams ISO
variable "streams_iso" {
  description = "The path to your CentOS Streams ISO."
  type        = object({
    url    = string
    shasum = string
  })
  default = {
    url    = "http://lon.mirror.rackspace.com/centos-stream/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso"
    shasum = "sha256:91c95c2e5070595aebeda64b8c49ee0122dc891bcbbb8897f6c6b8c86c7860ff"
  }
}

// Populate these for Azure ARM by default.
variable "ARM_CLIENT_ID" {
  default = env("ARM_CLIENT_ID")
}

variable "ARM_CLIENT_SECRET" {
  default = env("ARM_CLIENT_SECRET")
}

variable "ARM_SUBSCRIPTION_ID" {
  default = env("ARM_SUBSCRIPTION_ID")
}

variable "ARM_TENANT_ID" {
  default = env("ARM_TENANT_ID")
}


// Parameterize the CentOS Streams ISO
variable "outputs" {
  description = "The path to output."
  type        = object({
    path    = string
  })
  default = {
    path    = "/aux/packer"
  }
}

// Parameterize VirtualBox ISO additions for the builder.
variable "vbox_additions" {
  description = "Custom VirtualBox Additions ISO."
  type        = object({
    url    = string
    shasum = string
  })
  default = {
    url    = "http://lon.mirror.rackspace.com/centos-stream/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso"
    shasum = "sha256:5af0d4535a13e8b1c5129df85f6e8c853f0a82f77d8614d4f91187bc7aa94d52"
  }
}

// Chapter 06 - Builders explained.
source "virtualbox-iso" "hello-base-streams-ovf" {
  boot_command            = ["<esc><wait>", "vmlinuz initrd=initrd.img ", "inst.ks=https://github.com/jboero/hashistack/raw/master/http/ks-centosStreams.cfg", "<enter>"]
  boot_wait               = "3s"
  communicator            = "ssh"
  cpus                    = 4
  disk_size               = 100000
  guest_additions_mode    = "attach"
  guest_additions_sha256  = "62a0c6715bee164817a6f58858dec1d60f01fd0ae00a377a75bbf885ddbd0a61"
  guest_additions_url     = "https://download.virtualbox.org/virtualbox/6.1.10/VBoxGuestAdditions_6.1.10.iso"
  guest_os_type           = "RedHat_64"
  headless                = true
  iso_url                 = var.streams_iso.url
  iso_checksum            = var.streams_iso.shasum
  memory                  = 8192
  #output_filename         = "base-streams.ovf"
  pause_before_connecting = "10s"
  shutdown_command        = "shutdown -P now"
  ssh_username            = "root"
  ssh_password            = local.rootpw
  ssh_timeout             = "20m"
  vm_name                 = "packer-base-streams"
  vboxmanage = [
      [ "modifyvm", "{{.Name}}", "--paravirtprovider=kvm" ],
 ]
}

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
source "amazon-ebs" "gold_rhel9_latest" {
  ami_name      = "gold_rhel9_latest"
  communicator  = "ssh"
  instance_type = "t2.micro"
  source_ami    = data.amazon-ami.el9-amd64.id
  ssh_username  = "root"
  deprecate_at  = timeadd(timestamp(), "240h")
  ami_regions   = ["us-east-2", "eu-west-2"]
}

source "azure-arm" "gold_rhel9" {
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  subscription_id = var.ARM_SUBSCRIPTION_ID
  tenant_id       = var.ARM_TENANT_ID
  /**/
  resource_group_name    = "packer"
  storage_account        = "packer"

  capture_container_name = "images"
  capture_name_prefix    = "packer"

  os_type         = "Linux"
  image_publisher = "RedHat"
  image_offer     = "RHEL"
  image_sku       = "9.0"
  image_version   = "latest"

  azure_tags = {
    builder = "packer"
  }

  location = "West Europe"
  vm_size = "Standard_A1"
}

source "azure-chroot" "gold_rhel9" {
  image_resource_id = "/subscriptions/YOURSUB/resourceGroups/YOURRG/providers/Microsoft.Compute/images/gold-RHEL9"
  source            = "redhat:rhel:9:latest"
}

source "googlecompute" "basic-example" {
  project_id = vars.gcp_proj
  source_image = "rhel-9-v20220719"
  ssh_username = "packer"
  zone = "eu-west4-a"
}

source "qemu" "gold_centos9_latest" {
  accelerator = "kvm"
  #headless = true
  cpus = 8
  memory = 4096
  disk_size = "10G"

  #disk_image    = true
  #iso_url		   = "file:///aux/kvm/CentOS-Stream-GenericCloud-9-20220509.0.x86_64.qcow2"
  #iso_url       = "file:///aux/iso/rhel-baseos-9.0-beta-0-x86_64-dvd.iso"
  #iso_url       = "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20220509.0.x86_64.iso"
  #iso_url        = "file:///aux/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso"
  iso_url      = var.streams_iso.url
  iso_checksum = var.streams_iso.shasum
  #iso_checksum = "none"

  # For maximum build speed, use TMPFS if you have enough RAM.
  output_directory = "${var.outputs.path}/qcow"

  vm_name = "bases.qcow2"
  net_device = "virtio-net"
  disk_interface = "virtio"
  qemuargs = [["-cpu", "host"]]
  boot_wait = "1s"
  boot_key_interval = "10ms"
  boot_command = [
    "<tab> inst.ks=https://raw.githubusercontent.com/PacktPublishing/HashiCorp-Packer-in-Production/main/Chapter06/ks-centosStreams9.cfg<enter><wait>"
  ]

  # Communicator
  communicator = "ssh"
  ssh_username = "root"
  ssh_password = local.rootpw
  ssh_timeout = "30m"
  #ssh_certificate_file = <<EOF
  #TEST
  #EOF
}

source "virtualbox-iso" "gold_ubuntu_base" {
  boot_command            = [
        "<enter><enter><f6><esc><wait> ",
        "autoinstall ds=nocloud-net,#;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
        "<enter><wait>"
      ]
  boot_wait               = "3s"
  communicator            = "ssh"
  cpus                    = 4
  disk_size               = 100000
  guest_additions_mode    = "attach"
  guest_additions_sha256  = "62a0c6715bee164817a6f58858dec1d60f01fd0ae00a377a75bbf885ddbd0a61"
  guest_additions_url     = "https://download.virtualbox.org/virtualbox/6.1.10/VBoxGuestAdditions_6.1.10.iso"
  guest_os_type           = "RedHat_64"
  headless                = true
  iso_checksum            = "sha256:f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
  iso_url                 = "https://releases.ubuntu.com/20.04.3/ubuntu-20.04.3-live-server-amd64.iso"
  memory                  = 8192
  output_filename         = "base-ubuntu.ovf"
  pause_before_connecting = "10s"
  shutdown_command        = "shutdown -P now"
  ssh_username            = "root"
  ssh_password            = local.rootpw
  ssh_timeout             = "20m"
  vm_name                 = "packer-base-ubuntu"
  vboxmanage = [
      [ "modifyvm", "{{.Name}}", "--paravirtprovider=kvm" ],
 ]
}

source "virtualbox-iso" "hello-base-windows-server" {
  boot_command            = [
        "<enter><enter><f6><esc><wait> ",
        "autoinstall ds=nocloud-net,#;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
        "<enter><wait>"
      ]
  boot_wait               = "3s"
  communicator            = "ssh"
  cpus                    = 4
  disk_size               = 100000
  guest_additions_mode    = "attach"
  guest_additions_sha256  = "62a0c6715bee164817a6f58858dec1d60f01fd0ae00a377a75bbf885ddbd0a61"
  guest_additions_url     = "https://download.virtualbox.org/virtualbox/6.1.10/VBoxGuestAdditions_6.1.10.iso"
  guest_os_type           = "RedHat_64"
  headless                = true
  iso_checksum            = "sha256:4f1457c4fe14ce48c9b2324924f33ca4f0470475e6da851b39ccbf98f44e7852"
  iso_url                 = "file:///aux/iso/20348.169.210806-2348.fe_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
  memory                  = 8192
  output_filename         = "base-windows.ovf"
  pause_before_connecting = "10s"
  shutdown_command        = "shutdown -P now"
  ssh_username            = "root"
  ssh_password            = local.rootpw
  ssh_timeout             = "20m"
  vm_name                 = "packer-base-ubuntu"
  vboxmanage = [
      [ "modifyvm", "{{.Name}}", "--paravirtprovider=kvm" ],
 ]
}

source "qemu" "base-aarch64" {
  accelerator = "none"
  qemu_binary = "qemu-system-aarch64"
  machine_type = "virt"
  headless = true
  memory = 1024
  disk_size = "10G"
  ssh_username = "root"
  iso_url = "file:///aux/iso/Fedora-Server-netinst-x86_64-36-1.5.iso"
  iso_checksum = "421c4c6e23d72e4669a55e7710562287ecd9308b3d314329960f586b89ccca19"
  disk_image = true
  net_device = "e1000"
  #output_filename = "base-aarch64.qcow2"

  qemuargs =[
    ["-S"],
    #["-object","{\"qom-type\":\"secret\",\"id\":\"masterKey0\",\"format\":\"raw\",\"file\":\"/var/lib/libvirt/qemu/domain-1-fedora33-aarch64/master-key.aes\"} "],
    ["-blockdev","{\"driver\":\"file\",\"filename\":\"/usr/share/edk2/aarch64/QEMU_EFI-pflash.raw\",\"node-name\":\"libvirt-pflash0-storage\",\"auto-read-only\":true,\"discard\":\"unmap\"} "],
    ["-blockdev","{\"node-name\":\"libvirt-pflash0-format\",\"read-only\":true,\"driver\":\"raw\",\"file\":\"libvirt-pflash0-storage\"} "],
    ["-blockdev","{\"driver\":\"file\",\"filename\":\"/var/lib/libvirt/qemu/nvram/fedora33-aarch64_VARS.fd\",\"node-name\":\"libvirt-pflash1-storage\",\"auto-read-only\":true,\"discard\":\"unmap\"} "],
    ["-blockdev","{\"node-name\":\"libvirt-pflash1-format\",\"read-only\":false,\"driver\":\"raw\",\"file\":\"libvirt-pflash1-storage\"}" ],
    ["-machine","virt,accel=tcg,usb=off,dump-guest-core=off,gic-version=2,pflash0=libvirt-pflash0-format,pflash1=libvirt-pflash1-format" ],
    
    ["-boot","strict=on"],
    ["-cpu","cortex-a72"],
    ["-device","pcie-root-port,port=0x8,chassis=1,id=pci.1,bus=pcie.0,multifunction=on,addr=0x1" ],
    ["-device","pcie-root-port,port=0x9,chassis=2,id=pci.2,bus=pcie.0,addr=0x1.0x1" ],
    ["-device","pcie-root-port,port=0xa,chassis=3,id=pci.3,bus=pcie.0,addr=0x1.0x2" ],
    ["-device","pcie-root-port,port=0xb,chassis=4,id=pci.4,bus=pcie.0,addr=0x1.0x3" ],
    ["-device","pcie-root-port,port=0xc,chassis=5,id=pci.5,bus=pcie.0,addr=0x1.0x4" ],
    ["-device","pcie-root-port,port=0xd,chassis=6,id=pci.6,bus=pcie.0,addr=0x1.0x5" ],
    ["-device","pcie-root-port,port=0xe,chassis=7,id=pci.7,bus=pcie.0,addr=0x1.0x6" ],
    ["-device","pcie-root-port,port=0xf,chassis=8,id=pci.8,bus=pcie.0,addr=0x1.0x7" ],
    ["-device","qemu-xhci,p2=15,p3=15,id=usb,bus=pci.2,addr=0x0" ],
    ["-device","virtio-serial-pci,id=virtio-serial0,bus=pci.3,addr=0x0" ],
    ["-netdev","user,id=n1,ipv6=off"],
    ["-device","e1000,netdev=n1,mac=52:54:98:76:54:32"]
  ]
}

source "null" "localhost" {
  /**/
  ssh_host = "localhost"
  ssh_username = "youruser"
  ssh_agent_auth = true
  ssh_timeout = "2s"
  /**/
  #ssh_key_exchange_algorithms = ["curve25519-sha256@libssh.org","ecdh-sha2-nistp256",
  #  "ecdh-sha2-nistp384","ecdh-sha2-nistp521"]
  #ssh_ciphers = [ "aes128-gcm@openssh.com", "chacha20-poly1305@openssh.com", "aes128-ctr", "aes192-ctr", "aes256-ctr"]
}

source "vsphere-iso" "gold_rhel9_latest" {
  CPUs                 = 2
  RAM                  = 2048
  RAM_reserve_all      = false
  boot_command         = []
  boot_wait            = "1s"
  disk_controller_type = ["pvscsi"]
  floppy_files         = ["${path.root}/answerfile", "${path.root}/setup.sh"]
  guest_os_type        = "other3xLinux64Guest"
  host                 = "hv01.vcenter.yourco.com"

  iso_paths            = ["[datastore1] ISO/rhel-9.0.0-x86_64.iso"]
  network_adapters {
    network_card = "vmxnet3"
  }

  storage {
    disk_size             = 1024
    disk_thin_provisioned = true
  }

  // Creds for VCenter connectivity.
  username       = local.vsphere_user
  password       = local.vsphere_pw
  vcenter_server = "dev.vcenter.yourco.com"
  vm_name        = "packer"

  // Creds for SSH Communicator
  ssh_username = "root"
  ssh_password = local.rootpw
}

// Define a build with our single source builder and two provisioners.
build {
  sources = [
    #"sources.vsphere-iso.vsphere-base"
    #"sources.null.localhost"
    #"sources.qemu.hello-base-streams"
    "sources.amazon-ebs.gold_rhel9_latest"
    ]

  /*
  provisioner "file" {
    destination = "/etc/motd"
    direction   = "upload"
    content     = "Hello world from Packer."
  }*/

  /*  Sample calling Ansible plugin.
  provisioner "ansible" {
    playbook_file = "./playbook.yml"
  }
  */

  provisioner "shell-local" {
    inline = [
      <<EOF
ansible-playbook /dev/stdin <<ANS
---
# playbook.yml
- name: Hello Ansible from Packer
  hosts: ${source.name}
  tasks:
    - name: Create a file in tmp.
      copy:
        content: Hello world from ansible run via Packer build ${build.ID}
        dest: /tmp/packeransible.txt
ANS
      EOF 
    ]
  }

  /* Sample pzstd compression post step.
  post-processor "shell-local" {
    inline = [ "pzstd --rm ${var.outputs.path}/${build.name}" ]
  }
  */

  post-processors {
    post-processor "shell-local" { # create an artifice.txt file containing "hello"
      inline = [ "echo ${build.PackerRunUUID}" ]
    }
  }

  # On error try to copy the remote /var/log/ dir for the build and build_id
  # Note the communicator user will need read access to all of /var/log
  error-cleanup-provisioner "file" { 
    source = "/var/log/" 
    destination = "/mnt/packer/ERROR/${source.name}.${build.ID}" 
    direction = "download" 
  }
}

