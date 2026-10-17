output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}

output "sg" {
  value = aws_security_group.tf_sg.id
}

output "subnet_ids" {
  value = data.aws_subnets.all.ids
}

output "ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "public_ip" {
  value = {
    home   = aws_instance.home.public_ip
    laptop = aws_instance.laptop.public_ip
    mobile = aws_instance.mobile.public_ip
  }
}
