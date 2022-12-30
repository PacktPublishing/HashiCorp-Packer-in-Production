source "docker" "base_ubuntu" {
    image = "library/ubuntu:latest"
    export_path = "${source.name}.tar"
    platform = "linux/${source.value}"
}

build{
    sources = ["docker.base_ubuntu"]

    hcp_packer_registry {
        #bucket_name = "example-amazon-ebs-custom"
        description = "Golden image for Amazon-backed applications"

        bucket_labels = {
            "team" = "packer",
            "os"   = "RHEL"
        }

        build_labels = {
            "ubuntu_base" = "9.1",
            "build-time" = timestamp()
        }
    }
}
