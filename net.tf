resource "aws_internet_gateway" "my_igw" {
  for_each = var.web_servers
  vpc_id   = aws_vpc.web_srv_vpc[each.key].id
}

resource "aws_route" "route_to_igw" {
  for_each               = var.web_servers
  route_table_id         = aws_route_table.peering_route[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw[each.key].id
}

resource "aws_vpc" "web_srv_vpc" {
  for_each   = var.web_servers
  cidr_block = each.value.vpc_cidr
  tags = {
    Name = "${each.key}-vpc"
  }
}

resource "aws_subnet" "web_server_subnet" {
  for_each          = var.web_servers
  vpc_id            = aws_vpc.web_srv_vpc[each.key].id
  cidr_block        = each.value.subnet_cidr
  availability_zone = var.avaliability_zone
  tags = {
    Name = "${each.key}-private-subnet"
  }
}

resource "aws_vpc_peering_connection" "peering_connections" {
  for_each    = var.web_servers
  peer_vpc_id = aws_vpc.web_srv_vpc[each.value.accepter_peering_friend_key].id
  vpc_id      = aws_vpc.web_srv_vpc[each.key].id
  auto_accept = true
  tags = {
    Name = "${each.key}-${each.value.accepter_peering_friend_key}-peering"
  }
}

resource "aws_route_table" "peering_route" {
  for_each = var.web_servers
  vpc_id   = aws_vpc.web_srv_vpc[each.key].id

  route {
    cidr_block                = aws_subnet.web_server_subnet[each.value.accepter_peering_friend_key].cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_connections[each.key].id
  }

  route {
    cidr_block                = aws_subnet.web_server_subnet[each.value.requester_peering_friend_key].cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering_connections[each.value.requester_peering_friend_key].id
  }

}

resource "aws_route_table_association" "peering_association" {
  for_each       = var.web_servers
  subnet_id      = aws_subnet.web_server_subnet[each.key].id
  route_table_id = aws_route_table.peering_route[each.key].id
}
