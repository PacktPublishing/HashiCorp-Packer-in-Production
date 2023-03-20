# HashiCorp-Packer-in-Production
HashiCorp Packer in Production, Published by Packt

![HashiCorp Packer in Production](https://m.media-amazon.com/images/I/41PQ7yJQjFL.jpg)

This repository contains sample code and Packer templates for the book HashiCorp Packer in Production by John Boero. Updates and corrections will be available here and feedback is welcome via pull request.

## Chapter 1: Packer Fundamentals
1. Packer Architecture
2. History of Packer
3. Who uses Packer?
4. Installing Packer
5. HCL vs JSON
   
## Chapter 2: Creating Your First Template
1. Hello World manifest for a local VM
2. Breakdown of manifest components
3. Using an IDE to help you write manifests
4. Applying the VirtualBox builder

## Chapter 3: Configuring Builders and Sources
1. Simplifying your manifest with variables 
2. Utilizing local system builders 
3. Adding cloud builders 

## Chapter 4: Provisioners
1. Installing to disk from classic install media, ISO, or network boot
2. Applying installation profiles, kickstarts, jumpstarts, or package groups 
3. Running Ansible playbooks, Chef recipes, and Puppet manifests and profiles
4. Installing cloud or hypervisor agents 
5. Enabling common services on first boot 
6. Container connections and shell tasks

## Chapter 5: Logging and Troubleshooting
1. Managing stderr and stdout
2. Using environment variables for logging and debugging
3. Controlling flow 
4. Using breakpoints

## Chapter 6: Working with Builders
1. Adding applications deployable from vSphere
2. Adding an AWS EC2 AMI build
3. Adding an Azure build
4. Adding a Google GCP build
5. Parallel builds
6. CI testing against multiple OS releases
7. Pitfalls and Tthings to Aavoid

## Chapter 7: Building an Image Hierarchy
1. Starting with LXC/LXD container images
2. Docker container image format
3. Podman/buildah plugin for OCI container image format
4. Base image strategy
5. Aggregation and branching out multiple pipelines

## Chapter 8: Scaling Large Builds
1. Speeding up your builds with parallel processes
2. Preventing parallel processes from causing DoS
3. Troubleshooting logs in a parallel world
4. Using image compression
5. Selecting a compression algorithm for Packer images
6. Selecting the right storage type for the image lifecycle
7. Delta and patch strategies

## Chapter 9: Managing Image Lifecycle
1. Tracking image lifecycle 
2. Using the Manifest post provisioner 
3. Creating a retention policy 

## Chapter 10: Using HCP Packer
1. Creating an HCP Organization
2. Configuring HCP Packer in your templates
3. Consuming HCP Packer from Terraform
4. Using HCP Image Ancestry
5. Exploring the HCP REST API

## Chapter 11: Automating Packer Builds
1. Identifying common automation requirements
2. Exploring basic GitHub Actions support
3. Exploring GitLab CI pipeline support
4. Using Vault integration for pipelines

## Chapter 12: Developing Packer Plugins
1. Basics of GoLang
2. Sample plugin source
3. Building and testing your plugin
4. Protecting yourself from bad plugins

Note: Chapter 12 requires its own dedicated GitHub repo: https://github.com/jboero/packer-plugin-nspawn
