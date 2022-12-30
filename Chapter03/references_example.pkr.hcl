/*  A HCL2 Sample Packer manifest.
    John Boero   */
// A sample manifest to show "reference" sources.
// Here we declare a source as a template to be re-used with multiple variants.
// Fields which are commented with # will be specified in the build block.
source "qemu" "base" {
  accelerator = "none"
  #qemu_binary = "qemu-system-aarch64"
  machine_type = "virt"
  headless = false
  memory = 1024
  disk_size = "10G"
  ssh_username = "root"
  #iso_url = "file:///aux/iso/Fedora-Server-35-1.2.aarch64.raw"
  #iso_checksum = "ba106246cf20f31d74ebcde486f9542367e05652572c1d19f811c88305c02411"
  disk_image = true
}

// Define a build with our single source builder and two provisioners.
build {
  // One instance of qemu.base for aarch64 named "version-aarch64"
  source "qemu.base"{
    name = "version-aarch64"
    qemu_binary = "qemu-system-aarch64"
    iso_url = "file:///aux/iso/CentOS-Stream-9-latest-aarch64-dvd1.iso"
    iso_checksum = "78ffeac69712218f3dd06dcdf6d679b9e790d584ee94439762c075d66316a9d2"
  }

  // Second instance of qemu.base for x86_64 named "version-x86_64"
  source "qemu.base"{
    name = "version-x86_64"
    qemu_binary = "qemu-system-x86_64"
    iso_url = "file:///aux/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso"
    iso_checksum = "39a562c1ea8156b84608fee7f9879ac5566db6b16d8d6a570bbde9a37564745d"
  }

  provisioner "file" {
    destination = "/etc/motd"
    direction   = "upload"
    content     = "Hello world from Packer."
  }
}

