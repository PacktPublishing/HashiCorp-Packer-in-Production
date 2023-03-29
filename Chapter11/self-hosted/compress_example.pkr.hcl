// Build equivalent LAMP images from Fedora and Ubuntu Cloud images.
// Images must be prepped locally first for root password and SSH agent keys.

source "qemu" "fedora-lamp" {
  accelerator = "kvm"
  #headless = true
  cpus = 4
  memory = 4096
  disk_size = "20G"
  disk_image = true
  iso_urls = [
    "/tmp/Fedora-Cloud-Base-37-1.7.x86_64.qcow2",
    "https://download.fedoraproject.org/pub/fedora/linux/releases/37/Cloud/x86_64/images/Fedora-Cloud-Base-37-1.7.x86_64.qcow2",
  ]
  iso_checksum = "sha256:b5b9bec91eee65489a5745f6ee620573b23337cbb1eb4501ce200b157a01f3a0"

  net_device = "virtio-net"
  disk_interface = "virtio"
  qemuargs = [["-cpu", "host"]]

  # Communicator
  communicator = "ssh"
  ssh_username = "root"
  ssh_agent_auth = true
  headless = true
}

source "qemu" "ubuntu-lamp" {
  accelerator = "kvm"
  #headless = true
  cpus = 4
  memory = 4096
  disk_size = "20G"
  disk_image = true
  iso_url = "/tmp/bionic-server-cloudimg-amd64.img"
  iso_checksum = "none"
  boot_command = ["<enter>"]

  net_device = "virtio"
  disk_interface = "virtio"
  qemuargs = [["-cpu", "host"],
      ["-device", "virtio-net,netdev=user.0"]]

  # Communicator
  communicator = "ssh"
  ssh_username = "root"
  ssh_agent_auth = true
  ssh_timeout = "2h"
}

build {
  sources = [
    "qemu.fedora-lamp",
    #"qemu.ubuntu-lamp"
    ]

  provisioner "shell" {
    only = ["qemu.fedora-lamp"]
    inline = [
      <<EOF
cat > /etc/yum.repos.d/mondogb.repo<<EREPO
[Mongodb]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
EREPO

dnf install -y tuned nodejs mongodb-org mongodb-org-server
systemctl enable --now tuned
tuned-adm profile virtual-guest

npm install -g express 

dnf clean all
fstrim -v /
      EOF 
    ]
  }

  provisioner "shell" {
    only = ["qemu.ubuntu-lamp"]
    inline = [
      <<EOF
apt-get update
apt upgrade
      EOF 
    ]
  }

  /* Sample built-in compression post processor. */
  #post-processor "compress" {
  #  output = "{{.BuildName}}.gz"
  #}

  /** /
   Apply custom compression with parallel Zstd.
   This will require zstd to be installed on the local machine.
  /**/
  post-processor "shell-local" {
    inline = [ "pzstd  output-$PACKER_BUILD_NAME/packer-$PACKER_BUILD_NAME" ]
  }
  /**/
}
