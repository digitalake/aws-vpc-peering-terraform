# <h1 align="center">VPC Peering task</a>
### About
The Terraform code in this repo is designed to create instances in different VPCs with VPC-peering connections. Additionally the user_data script installs and starts the NginX Web Server.

### The scheme of the resources: 
> I added the Route tables screenshots from AWS Console

![Screenshot from 2023-08-25 17-24-08](https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/70ed8a5b-6805-46b8-8ea0-e2316b3e3448)

### About the Terraform code:

In this configuration i've used the _map(object)_ variable type to define the configuration for each web-server:

```
variable "web_servers" {
  type = map(object({
    vpc_cidr                     = string
    subnet_cidr                  = string
    instance_type                = string
    ami                          = string
    pub_key_path                 = string
    accepter_peering_friend_key  = string # use one of existing web_servers map's keys
    requester_peering_friend_key = string # use one of existing web_servers map's keys
  }))
}
```
 After the apply i have useful outputs:
 
<img src="https://github.com/digitalake/aws-vpc-peering-terraform/assets/109740456/24499c67-8303-4b27-b74a-0c1a750ebb64" width="550">

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
