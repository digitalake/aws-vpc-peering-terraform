resource "aws_security_group" "web_server_sg" {
  for_each = var.web_servers
  name     = "${each.key}security-group"
  vpc_id   = aws_vpc.web_srv_vpc[each.key].id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      aws_subnet.web_server_subnet[each.value.accepter_peering_friend_key].cidr_block,
      aws_subnet.web_server_subnet[each.value.requester_peering_friend_key].cidr_block
    ]
  }

  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
    cidr_blocks = [
      aws_subnet.web_server_subnet[each.value.accepter_peering_friend_key].cidr_block,
      aws_subnet.web_server_subnet[each.value.requester_peering_friend_key].cidr_block
    ]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}