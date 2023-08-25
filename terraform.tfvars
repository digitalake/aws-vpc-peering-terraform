web_servers = {
  "server1" = {
    subnet_key    = "vpc1subnet"
    instance_type = "t2.micro"
    ami           = "ami-02675d30b814d1daa"
    pub_key_path  = "/home/vanadium/.ssh/virt.pub"
  },
  "server2" = {
    subnet_key    = "vpc2subnet"
    instance_type = "t2.micro"
    ami           = "ami-02675d30b814d1daa"
    pub_key_path  = "/home/vanadium/.ssh/virt.pub"
  },
  "server3" = {
    subnet_key    = "vpc3subnet"
    instance_type = "t2.micro"
    ami           = "ami-02675d30b814d1daa"
    pub_key_path  = "/home/vanadium/.ssh/virt.pub"
  }
}

networks = {
  "vpc1" = {
    cidr_block = "10.0.0.0/16"
    subnets = {
      "vpc1subnet" = {
        cidr_block = "10.0.1.0/24"
      }
    }
  },
  "vpc2" = {
    cidr_block = "20.0.0.0/16"
    subnets = {
      "vpc2subnet" = {
        cidr_block = "20.0.1.0/24"
      }
    }
  },
  "vpc3" = {
    cidr_block = "30.0.0.0/16"
    subnets = {
      "vpc3subnet" = {
        cidr_block = "30.0.1.0/24"
      }
    }
  }
}

peering_scheme = {
  "vpc1" = ["vpc2"],
  "vpc2" = ["vpc3"],
  "vpc3" = ["vpc1"]
}