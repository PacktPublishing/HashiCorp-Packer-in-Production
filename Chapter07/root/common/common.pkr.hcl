# Common.hcl
# This file is included via symlink into multiple Packer directories.
# Not all of these are required but included as examples.

locals {
    chapter = 7
    applist = ["nginx", "sqlite", "jq", "git"]
    sources = [""]
}

variable "USER" {
    default = env("USER")
}

variable "DOCKER_REGISTRY" {
    description = "Docker registry used for pushing images."
    default = env("USER")
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

// Populate these for AWS if used
variable "AWS_ACCESS_KEY_ID"{
    description = "Env var for AWS access key ID."
    default = env("AWS_ACCESS_KEY_ID")
}

variable "AWS_SECRET_ACCESS_KEY"{
    description = "Env var for AWS secret access key."
    default = env("AWS_SECRET_ACCESS_KEY")
}

variable "AWS_DEFAULT_REGION"{
    description = "Env var for AWS default region."
    default = env("AWS_DEFAULT_REGION")
}

variable "AWS_REGIONS"{
    description = "Packer var for storing all of our images."
    default =  ["us-east-2", "eu-west-2"]
}

// Populate these for GCP if used.
variable "GCP_PROJECT" {
    default = env("GCP_PROJECT")
}

variable "CLOUDSDK_CONFIG" {
    default = env("CLOUDSDK_CONFIG")
}
