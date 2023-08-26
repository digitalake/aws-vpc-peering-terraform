web_servers = {
  "server1" = {
    subnet_key    = "vpc1subnet"
    vpc_key = "vpc1"
    instance_type = "t2.micro"
    ami           = "ami-02675d30b814d1daa"
    pub_key_path  = "/home/vanadium/.ssh/virt.pub"
  },
  "server2" = {
    subnet_key    = "vpc2subnet"
    vpc_key = "vpc2"
    instance_type = "t2.micro"
    ami           = "ami-02675d30b814d1daa"
    pub_key_path  = "/home/vanadium/.ssh/virt.pub"
  },
  "server3" = {
    subnet_key    = "vpc3subnet"
    vpc_key = "vpc3"
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
  "vpc1" = {
    peering_accepters  = ["vpc2"]
    peering_requesters = ["vpc3"]
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
