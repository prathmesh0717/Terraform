vpc_cidr_block = "192.168.0.0/16"
aws_subnet     = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
aws_az         = ["us-east-1a", "us-east-1b", "us-east-1c"]
sg_ports       = [22, 80, 443, 8080, 0]
ami_id         = "ami-0b6d9d3d33ba97d99"
instance_type  = "t3.micro"
key_name       = "personal-key"
instance_tags = {
  Name = "VM"
}
instance_tags_dev = {
  Environment = "Development"
}
