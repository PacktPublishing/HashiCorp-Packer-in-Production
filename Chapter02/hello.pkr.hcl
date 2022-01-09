/*  A HCL2 Sample Packer manifest.
    John Boero   */
// HCL2 extrapolates builders as "sources"
source "virtualbox-iso" "hello-base" {
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
  iso_checksum            = "sha256:5af0d4535a13e8b1c5129df85f6e8c853f0a82f77d8614d4f91187bc7aa94d52"
  iso_url                 = "http://lon.mirror.rackspace.com/centos-stream/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso"
  memory                  = 8192
  output_filename         = "hello-world.ovf"
  pause_before_connecting = "10s"
  shutdown_command        = "shutdown -P now"
  ssh_username            = "root"
  ssh_password            = "packer"
  ssh_timeout             = "20m"
  vm_name                 = "hello-world"
  vboxmanage = [
      [ "modifyvm", "{{.Name}}", "--paravirtprovider=kvm" ],
 ]
}

// Define a build with our single source builder and two provisioners.
build {
 sources = ["source.virtualbox-iso.hello-base"]
 provisioner "file" {
   destination = "/etc/motd"
   direction   = "upload"
   content     = "Hello world from Packer."
 }
}
