output "web-servers-private-addresses" {
  value = { for instance in aws_instance.web_server : instance.tags.Name => instance.private_ip }
}

output "web-servers-public-addresses" {
  value = { for instance in aws_instance.web_server : instance.tags.Name => "${instance.public_ip}, ssh: ssh -i ~/.ssh/virt ubuntu@${instance.public_ip}" }
}
