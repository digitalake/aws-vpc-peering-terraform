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

variable "avaliability_zone" {
  type    = string
  default = "us-east-1a"
}