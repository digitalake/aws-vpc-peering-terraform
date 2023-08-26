resource "aws_internet_gateway" "vpc_igw" {
  for_each = var.networks
  vpc_id   = aws_vpc.web_server_vpc[each.key].id
}

resource "aws_route" "route_to_igw" {
  for_each               = var.networks
  route_table_id         = aws_route_table.vpc_route_table[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_igw[each.key].id
}

resource "aws_vpc" "web_server_vpc" {
  for_each   = var.networks
  cidr_block = each.value.cidr_block
  tags = {
    Name = "${each.key}"
  }
}

resource "aws_subnet" "web_server_subnet" {
  for_each = {
    for network_subnet in local.network_subnet : network_subnet.subnet_key => network_subnet
  }
  vpc_id            = aws_vpc.web_server_vpc[each.value.network_key].id
  cidr_block        = each.value.subnet_cidr
  availability_zone = var.avaliability_zone
  tags = {
    Name = "${each.key}"
  }
}

resource "aws_vpc_peering_connection" "peerings" {
#  for_each = toset(local.peering_pairs_outbound)
  for_each = {
    for pair in local.peering_pairs_outbound :
    "${pair.requester}" => pair
  }
  peer_vpc_id = aws_vpc.web_server_vpc[each.value.accepter].id
  vpc_id      = aws_vpc.web_server_vpc[each.value.requester].id
  auto_accept = true

  tags = {
    Name = "${each.value.requester}-${each.value.accepter}-peering"
  }
}

resource "aws_route_table" "vpc_route_table" {
  for_each = var.networks
  vpc_id   = aws_vpc.web_server_vpc[each.key].id
}

resource "aws_route" "outbound_peering_routes" {
  for_each                  = {
    for pair in local.peering_pairs_outbound :
    "${pair.requester}-${pair.accepter}" => pair
  }
  route_table_id            = aws_route_table.vpc_route_table[each.value.requester].id
  destination_cidr_block    = aws_vpc.web_server_vpc[each.value.accepter].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peerings[each.value.requester].id
}

resource "aws_route" "inbound_peering_routes" {
  for_each                  = {
    for pair in local.peering_pairs_inbound :
    "${pair.accepter}-${pair.requester}" => pair
  }
  route_table_id            = aws_route_table.vpc_route_table[each.value.accepter].id
  destination_cidr_block    = aws_vpc.web_server_vpc[each.value.requester].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peerings[each.value.requester].id
}

resource "aws_route_table_association" "peering_association" {
  for_each = {
    for network_subnet in local.network_subnet : network_subnet.subnet_key => network_subnet
  }
  subnet_id      = aws_subnet.web_server_subnet[each.value.subnet_key].id
  route_table_id = aws_route_table.vpc_route_table[each.value.network_key].id
}
