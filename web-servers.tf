resource "aws_key_pair" "web_server_access" {
  for_each   = var.web_servers
  key_name   = "${each.key}-pub_key"
  public_key = file("${each.value.pub_key_path}")
}

resource "aws_instance" "web_server" {
  for_each                    = var.web_servers
  instance_type               = each.value.instance_type
  ami                         = each.value.ami
  key_name                    = aws_key_pair.web_server_access[each.key].key_name
  subnet_id                   = aws_subnet.web_server_subnet[each.value.subnet_key].id
  vpc_security_group_ids      = [aws_security_group.basic[each.value.vpc_key].id, aws_security_group.allow_peering_mesh[each.value.vpc_key].id]
  associate_public_ip_address = true
  user_data = templatefile("${path.module}/templates/user_data.tftpl", {
    SERVER = "${each.key}"
  })
  tags = {
    Name = "${each.key}"
  }
}