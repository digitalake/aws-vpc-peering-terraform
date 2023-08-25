web_servers = {
  "server1" = {
    vpc_cidr                     = "10.0.0.0/16"
    subnet_cidr                  = "10.0.1.0/24"
    instance_type                = "t2.micro"
    ami                          = "ami-02675d30b814d1daa"
    pub_key_path                 = "/home/vanadium/.ssh/virt.pub"
    accepter_peering_friend_key  = "server2" 
    requester_peering_friend_key = "server3" 
  },
  "server2" = {
    vpc_cidr                     = "20.0.0.0/16"
    subnet_cidr                  = "20.0.1.0/24"
    instance_type                = "t2.micro"
    ami                          = "ami-02675d30b814d1daa"
    pub_key_path                 = "/home/vanadium/.ssh/virt.pub"
    accepter_peering_friend_key  = "server3"
    requester_peering_friend_key = "server1"
  },
  "server3" = {
    vpc_cidr                     = "30.0.0.0/16"
    subnet_cidr                  = "30.0.1.0/24"
    instance_type                = "t2.micro"
    ami                          = "ami-02675d30b814d1daa"
    pub_key_path                 = "/home/vanadium/.ssh/virt.pub"
    accepter_peering_friend_key  = "server1"
    requester_peering_friend_key = "server2"
  }
}