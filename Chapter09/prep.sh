#!/bin/bash -x
# A setup script to download and configure root password for a cloud image for this example.
# Requires libguestfs-tools package.

cd /tmp

function prepimage()
{
    # Get the cloud image to /tmp (storage space required)
    wget "$1"
    img=$(basename "$1")
    # Use virt-customize to add our ssh key and restorecon for SELinux
    virt-customize -a "$img" --ssh-inject root:file:$HOME/.ssh/id_rsa.pub \
        --root-password password:packer
        
    virt-customize -a "$img" --ssh-inject root:file:$HOME/.ssh/id_rsa.pub \
        --run-command "chcon -R unconfined_u:object_r:ssh_home_t:s0 /root/.ssh"
    
    virt-sysprep -a "$img" --operations firewall-rules
}

export -f prepimage

# Add images to list in the heredoc
parallel prepimage {} <<EOF
https://cloud-images.ubuntu.com/bionic/20221006/bionic-server-cloudimg-amd64.img
https://download.fedoraproject.org/pub/fedora/linux/releases/36/Cloud/x86_64/images/Fedora-Cloud-Base-36-1.5.x86_64.qcow2
EOF
