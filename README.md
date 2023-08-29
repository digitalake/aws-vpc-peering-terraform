# <h1 align="center">VPC Peering task</a>
### About
The Terraform code in this repo is designed to create instances in different VPCs with VPC-peering connections. Additionally the user_data script installs and starts the NginX Web Server. The idea i tried to follow is being able to change the number of peering vpcs and hosts there quickly by only changing the .tfvars. The SGs are created independently for each instance was created, same with the routing tables.

### The scheme of the resources: 
> I added the Route tables screenshots from AWS Console

![Screenshot from 2023-08-25 17-24-08](https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/70ed8a5b-6805-46b8-8ea0-e2316b3e3448)

### About the Terraform code:

In this configuration i've used the _map(object)_ variable type to define the configuration for each web-server:

```
variable "web_servers" {
  type = map(object({
    instance_type = string
    ami           = string
    pub_key_path  = string
    vpc_key       = string 
    subnet_key    = string
  }))
}
```

For the network configuration i'm using such variable:
```
variable "networks" {
  type = map(object({
    cidr_block = string
    subnets = map(object({
      cidr_block = string
    }))
  }))
}
```
The subnet's map of object is used for adding optional tags.

For the peering config i decided to implement such variable:
```
variable "peering_scheme" {
  type = map(object({
    peering_accepters  = list(string)
    peering_requesters = list(string)
  }))
}
```
An example of the value (there can be more values for each list, here the vpc number is 3 so no more needed):
```
peering_scheme = {
  "vpc1" = {
    peering_accepters  = ["vpc2"] --> used for defining the targets for creating peering connections FROM the vpc1
    peering_requesters = ["vpc3"] --> used for defining the VPCs of the incomming peering connections TO the vpc1
  },
  "vpc2" = {
    peering_accepters  = ["vpc3"]
    peering_requesters = ["vpc1"]
  },
  "vpc3" = {
    peering_accepters  = ["vpc1"]
    peering_requesters = ["vpc2"]
  }
}
```
 After the apply i have useful outputs:
 
<img src="https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/23a84981-4567-4a11-b1ec-927bb8f7f0b1" width="550">

The user_data script rewrites the default index.html to show the web_servers key form the map variable, to achive it i've created a template user_data.tftpl:

```
#!/bin/bash
apt update -y
apt install -y nginx

systemctl start nginx
systemctl enable nginx

echo "<html><head><title>Instance Info</title></head><body><h1>This is ${SERVER}</h1></body></html>" > /var/www/html/index.html
```

The value is being inserted by the _templatefile()_ function:

```
...
for_each = var.web_servers
...
user_data = templatefile("${path.module}/templates/user_data.tftpl", {
    SERVER = "${each.key}"
  })
...
```

### Results

For each of the instances i have the screenshots of _"pings"_ and _"curls"_

##### From web-server1

![Screenshot from 2023-08-25 16-32-11](https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/c2d4f5c8-aa53-4b98-b306-1665a80b8374)

![Screenshot from 2023-08-25 16-32-51](https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/c9589d8d-26c2-48b2-b860-167cead615ee)

<img src="https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/fbd3de87-99f6-4279-af79-d7f2a68f44ed" width="550">

<img src="https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/a65a800b-3a4a-499f-b7f1-0f6202c7038e" width="550">


##### From web-server2

![Screenshot from 2023-08-25 16-34-49](https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/55a9999e-b20f-45f4-8b44-6ef64601f34e)

![Screenshot from 2023-08-25 16-35-10](https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/ec760469-079c-4bc6-8c22-685c2112f87c)

<img src="https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/27dd35cf-583c-4fc7-88ab-32c4e79dcca1" width="550">

<img src="https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/7d317403-4311-459b-98cc-7151594e52f5" width="550">

##### From web-server3

![Screenshot from 2023-08-25 16-37-02](https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/347efd45-1fb7-42ab-be7b-95920d2300f4)

![Screenshot from 2023-08-25 16-37-25](https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/4fb66970-84a4-4efb-b7e4-9965370e5dcc)

<img src="https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/4ba7edc7-c08b-4af7-84c8-9d3b6658ba50" width="550">

<img src="https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/e35de403-be2f-4533-b8cf-a97b5f632a6b" width="550">
