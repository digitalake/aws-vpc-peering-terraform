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

  transformed_peering_scheme = flatten([
    for source, targets in var.peering_scheme : [
      for target in targets : {
        source = source,
        target = target
      }
    ]
  ])
}