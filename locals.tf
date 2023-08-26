locals {
  network_subnet = flatten([
    for network_key, network in var.networks : [
      for subnet_key, subnet in network.subnets : {
        network_key = network_key
        subnet_key  = subnet_key
        subnet_cidr = subnet.cidr_block
      }
    ]
  ])

  peering_pairs_outbound = flatten([
    for vpc, scheme in var.peering_scheme : [
      for target in scheme.peering_accepters : {
        requester = vpc
        accepter  = target
      }
    ]
  ])

  peering_pairs_inbound = flatten([
    for vpc, scheme in var.peering_scheme : [
      for hunter in scheme.peering_requesters : {
        requester = hunter
        accepter  = vpc
      }
    ]
  ])
}