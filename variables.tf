variable "web_servers" {
  type = map(object({
    instance_type                = string
    ami                          = string
    pub_key_path                 = string
  }))
}

variable "avaliability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "networks" {
  type = map(object({
    cidr_block   = string
    subnets = map(object({
      cidr_block = string
    }))
  }))
}

variable "peering_scheme" {
  type = map(list(string))
}