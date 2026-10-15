# VPC Output
output "vpc_id" {
  value = aws_vpc.Demo.id
}

output "vpc_cidr" {
  value = aws_vpc.Demo.cidr_block
}

# Subnet Outputs
output "public_subnet_1_id" {
  value = aws_subnet.pub-1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.pub-2.id
}

output "private_subnet_id" {
  value = aws_subnet.priv-sub.id
}

# Internet Gateway Output
output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

# Route Table Output
output "public_route_table_id" {
  value = aws_route_table.RT-Public.id
}

# Security Group Output
output "security_group_id" {
  value = aws_security_group.var-sg.id
}

# EC2 Instance IDs
output "instance_1_id" {
  value = aws_instance.vm-1.id
}

output "instance_2_id" {
  value = aws_instance.vm-2.id
}

output "instance_3_id" {
  value = aws_instance.vm-3.id
}

# EC2 Public IP Addresses
output "instance_1_public_ip" {
  value = aws_instance.vm-1.public_ip
}

output "instance_2_public_ip" {
  value = aws_instance.vm-2.public_ip
}

output "instance_3_public_ip" {
  value = aws_instance.vm-3.public_ip
}

# All EC2 Public IPs
output "all_public_ips" {
  value = [
    aws_instance.vm-1.public_ip,
    aws_instance.vm-2.public_ip,
    aws_instance.vm-3.public_ip
  ]
}

# EC2 Private IP Addresses
output "all_private_ips" {
  value = [
    aws_instance.vm-1.private_ip,
    aws_instance.vm-2.private_ip,
    aws_instance.vm-3.private_ip
  ]
}
