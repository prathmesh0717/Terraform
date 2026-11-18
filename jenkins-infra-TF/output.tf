/*# VPC Output
output "vpc_id" {
  value = aws_vpc.Demo.id
}

output "vpc_cidr" {
  value = aws_vpc.Demo.cidr_block
}
# Subnet Outputs
output "public_subnet_id" {
  value = aws_subnet.pub.id
}

# Internet Gateway Output
output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

# Route Table Output
output "public_route_table_id" {
  value = aws_route_table.RT-PUB.id
}

# Security Group Output
output "security_group_id" {
  value = aws_security_group.var_sg.id
}

# EC2 Instance IDs
output "instance_id" {
  value = aws_instance.vm-1.id
}

# EC2 Public IP Addresses
output "instance_1_public_ip" {
  value = aws_instance.vm-1.public_ip
}

# EC2 Private IP Addresses
output "instance_private_ip" {
  value = aws_instance.vm-1.private_ip

}*/