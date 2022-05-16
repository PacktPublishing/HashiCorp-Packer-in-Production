/*  A HCL2 Sample Packer manifest.
    John Boero   */
// HCL2 extrapolates builders as "sources"
packer {
  required_version = ">= 1.7.9"
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
    shasum = "sha256:5af0d4535a13e8b1c5129df85f6e8c853f0a82f77d8614d4f91187bc7aa94d52"
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
  output_filename         = "base-streams.ovf"
  pause_before_connecting = "10s"
  shutdown_command        = "shutdown -P now"
  ssh_username            = "root"
  ssh_password            = "packer"
  ssh_timeout             = "20m"
  vm_name                 = "packer-base-streams"
  vboxmanage = [
      [ "modifyvm", "{{.Name}}", "--paravirtprovider=kvm" ],
 ]
}

source "qemu" "hello-base-streams" {
  accelerator = "kvm"
  #headless = true
  cpus = 8
  memory = 4096
  disk_size = "10G"

  #disk_image    = true
  #iso_url		   = "file:///aux/kvm/CentOS-Stream-GenericCloud-9-20220509.0.x86_64.qcow2"
  #iso_url       = "file:///aux/iso/rhel-baseos-9.0-beta-0-x86_64-dvd.iso"
  #iso_url       = var.streams_iso.url
  iso_url       = "http://lon.mirror.rackspace.com/centos-stream/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-20220509.0-x86_64-boot.iso"
  
  iso_checksum = "none"
  #iso_checksum = var.streams_iso.shasum

  # For maximum build speed, use TMPFS if you have enough RAM.
  output_directory = "/tmp/packer"
  vm_name = "tdhtest"
  net_device = "virtio-net"
  disk_interface = "virtio"
  qemuargs = [["-cpu", "host"]]
  boot_wait = "1s"
  boot_key_interval = "25ms"
  boot_command = [
    "<tab> inst.ks=https://raw.githubusercontent.com/PacktPublishing/HashiCorp-Packer-in-Production/main/Chapter04/ks-centosStreams9.cfg<enter><wait>"
  ]

  # Communicator
  communicator = "ssh"
  ssh_username = "root"
  ssh_password = "kickstartpassword"
  ssh_timeout = "60m"
  ssh_certificate_file = <<EOF
  TEST
  EOF
}

source "virtualbox-iso" "hello-base-ubuntu-ovf" {
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
  ssh_password            = "packer"
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
  ssh_password            = "packer"
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
  iso_url = "file:///aux/iso/Fedora-Server-35-1.2.aarch64.raw"
  iso_checksum = "ba106246cf20f31d74ebcde486f9542367e05652572c1d19f811c88305c02411"
  disk_image = true
  net_device = "e1000"
  output_filename = "base-aarch64.qcow2"

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

// Define a build with our single source builder and two provisioners.
build {
 sources = [
   #"source.virtualbox-iso.hello-base-streams",
   #"source.virtualbox-iso.hello-base-ubuntu",
   #"source.virtualbox-iso.hello-base-windows-server",
   #"source.qemu.base-aarch64",
   "source.qemu.hello-base-streams"
   ]
 provisioner "file" {
   destination = "/etc/motd"
   direction   = "upload"
   content     = "Hello world from Packer."
 }
}

