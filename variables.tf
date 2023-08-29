variable "web_servers" {
  type = map(object({
    instance_type = string
    ami           = string
    pub_key_path  = string
    vpc_key       = string 
    subnet_key    = string
  }))
}

variable "avaliability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "networks" {
  type = map(object({
    cidr_block = string
    subnets = map(object({
      cidr_block = string
    }))
  }))
}

variable "peering_scheme" {
  type = map(object({
    peering_accepters  = list(string)
    peering_requesters = list(string)
  }))
}
