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

* HashiCorp Infrastructure Automation Certification Guide [[Packt]](https://www.packtpub.com/product/hashicorp-infrastructure-automation-certification-guide/9781800565975?utm_source=github&utm_medium=repository&utm_campaign=9781800565975) [[Amazon]](https://www.amazon.com/dp/1800565976)

## Get to Know the Author
**John Boero**
John Boero has 20 years of experience in the tech industry covering engineering, consulting, architecture, and pre-sales. He comes from Chicago, IL in the USA but currently lives in London, UK. He has worked for Red Hat, Puppet, and HashiCorp and remains active in the open source community. All commissions for this book will be donated to the Raspberry Pi Foundation non-profit to encourage coding and computing skills for kids.
