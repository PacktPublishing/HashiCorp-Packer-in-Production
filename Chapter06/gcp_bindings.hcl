# Example bindings for Vault roleset configuration.
resource "https://www.googleapis.com/compute/v1/projects/my-project/zone/my-zone/instances/my-instance" {
  roles = [
    "roles/compute.instanceAdmin.v1"
  ]
}
