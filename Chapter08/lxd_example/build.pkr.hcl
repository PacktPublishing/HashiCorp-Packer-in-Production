source "lxd" "example" {
  image = "ubuntu-daily:xenial"
  output_image = "ubuntu-xenial"
  publish_properties = {
    description = "Trivial repackage with Packer"
  }
}