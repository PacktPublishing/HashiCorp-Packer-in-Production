# HashiCorp Packer in Production

<a href="https://www.packtpub.com/product/hashicorp-packer-in-production/9781803246857?utm_source=github&utm_medium=repository&utm_campaign=9781786461629"><img src="https://content.packt.com/B18105/cover_image_small.jpg" alt="" height="256px" align="right"></a>

This is the code repository for [HashiCorp Packer in Production](https://www.packtpub.com/product/hashicorp-packer-in-production/9781803246857?utm_source=github&utm_medium=repository&utm_campaign=9781786461629), published by Packt.

**Efficiently manage sets of images for your digital transformation or cloud adoption journey**

## What is this book about?

This book covers the following exciting features:
* Build and maintain consistent system images across multiple platforms
* Create machine images that can be used in multiple environments
* Write a spec for a local Packer virtual machine in JSON and HCL
* Build a container image with Packer in different formats
* Automate Packer with continuous delivery pipelines
* Discover how to customize Packer by writing plugins

If you feel this book is for you, get your [copy](https://www.amazon.com/dp/1803246855) today!

<a href="https://www.packtpub.com/?utm_source=github&utm_medium=banner&utm_campaign=GitHubBanner"><img src="https://raw.githubusercontent.com/PacktPublishing/GitHub/master/GitHub.png" 
alt="https://www.packtpub.com/" border="5" /></a>

## Instructions and Navigations
All of the code is organized into folders. For example, Chapter01.

The code will look like the following:
```
post-processor "compress" {
    output = "{{.BuildName}}.gz"
    compression_level = 7
}
```

**Following is what you need for this book:**
This book is for DevOps engineers, Cloud engineers, and teams responsible for maintaining platform and application images for enterprise private, hybrid, or multi-cloud environments. Familiarity with operating systems and virtualization concepts, with or without using a cloud provider, is a prerequisite.

With the following software and hardware list you can run all code files present in the book (Chapter 1-12).
### Software and Hardware List
| Software/hardware covered in the book | Operating system  required |
| ------------------------------------ | ----------------------------------- |
| HCL2 | Platform agnostic |
| JSON | Platform agnostic |
| Golang | Platform agnostic |

We also provide a PDF file that has color images of the screenshots/diagrams used in this book. [Click here to download it](https://packt.link/GJ9i3).

### Related products
* Learning DevOps - Second Edition [[Packt]](https://www.packtpub.com/product/learning-devops-second-edition/9781801818964?utm_source=github&utm_medium=repository&utm_campaign=9781801818964) [[Amazon]](https://www.amazon.com/dp/1801818967)

* HashiCorp Infrastructure Automation Certification Guide [[Packt]](https://www.packtpub.com/product/hashicorp-infrastructure-automation-certification-guide/9781800565975?utm_source=github&utm_medium=repository&utm_campaign=9781800565975) [[Amazon]](https://www.amazon.com/dp/180056597


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
