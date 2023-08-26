resource "aws_security_group" "basic" {
  for_each = var.networks
  name     = "${each.key}-basic"
  vpc_id   = aws_vpc.web_server_vpc[each.key].id

  lifecycle {
    create_before_destroy = true
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

resource "aws_security_group" "allow_peering_mesh" {
  for_each = var.peering_scheme
  name     = "${each.key}-peering_mesh"
  vpc_id   = aws_vpc.web_server_vpc[each.key].id

  lifecycle {
    create_before_destroy = true
  }

  dynamic "ingress" {
    for_each = concat(each.value.peering_accepters, each.value.peering_requesters)
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = [aws_vpc.web_server_vpc[ingress.value].cidr_block]
    }
  }

  dynamic "ingress" {
    for_each = concat(each.value.peering_accepters, each.value.peering_requesters)
    content {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = [aws_vpc.web_server_vpc[ingress.value].cidr_block]
    }
  }
}