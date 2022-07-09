/*  A HCL2 Sample Packer manifest.
    John Boero   */
// HCL2 extrapolates builders as "sources"
source "virtualbox-iso" "hello-base" {
  boot_command            = [
    "<esc><wait>", 
    "vmlinuz initrd=initrd.img ", 
    "inst.ks=https://github.com/jboero/hashistack/raw/master/http/ks-centosStreams.cfg", 
    "<enter>"]
  boot_wait               = "3s"
  communicator            = "ssh"
  cpus                    = 2
  disk_size               = 100000
  guest_additions_mode    = "attach"
  guest_additions_sha256  = "62a0c6715bee164817a6f58858dec1d60f01fd0ae00a377a75bbf885ddbd0a61"
  guest_additions_url     = "https://download.virtualbox.org/virtualbox/6.1.10/VBoxGuestAdditions_6.1.10.iso"
  guest_os_type           = "RedHat_64"
  headless                = false
    
  // Checksums can be directly listed here or pulled from a file or URL
  // Using a URL simplifies things for changing upstreams but risks a compromised checksum
  // Use consistency and make sure any URLs can be trusted for security.
  // Also during development omitting checksum will save time.
  iso_checksum            = "file:https://lon.mirror.rackspace.com/centos-stream/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso.SHA256SUM"
  iso_url                 = "https://lon.mirror.rackspace.com/centos-stream/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso"
  memory                  = 1024
  output_filename         = "hello-world.ovf"
  pause_before_connecting = "10s"
  shutdown_command        = "shutdown -P now"
  ssh_username            = "root"
  ssh_password            = "packer"
  ssh_timeout             = "20m"
  vm_name                 = "hello-world"
  vboxmanage = [
    // Optionally put vboxmanage customization here.
    #[ "modifyvm", "{{.Name}}", "--paravirtprovider=kvm" ],
 ]
}

// Define a build with our single source builder and one provisioner.
build {
  sources = ["source.virtualbox-iso.hello-base"]
  provisioner "file" {
    destination = "/etc/motd"
    direction   = "upload"

    // Reference the local file "./motd" which must exist.  Relative or absolute path supported.
    source      = "motd"
      
    // File supports two options: contents for direct string or source for loading a file.
    // Contents also supports herefile syntax.
    # contents    = "This is an example of directly defined file content"
  }
}
