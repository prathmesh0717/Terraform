

# Security Group for ALB
resource "aws_security_group" "tf_sg" {
  name        = "terraform-alb-sg"
  vpc_id      = data.aws_vpc.test-tag.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-sg"
  }
}


# EC2-1: Home
resource "aws_instance" "home" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tf_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    mkdir -p /var/www/html/home
    echo "THIS IS HOME SERVER" > /var/www/html/index.html
    systemctl enable --now nginx
  EOF

  tags = {
    Name = "home-server"
  }
}


# EC2-2: Laptop
resource "aws_instance" "laptop" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tf_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    mkdir -p /var/www/html/laptop
    rm -f /var/www/html/index.html
    echo "THIS IS LAPTOP SERVER" > /var/www/html/laptop/index.html
    systemctl enable --now nginx
  EOF

  tags = {
    Name = "laptop-server"
  }
}


# EC2-3: Mobile
resource "aws_instance" "mobile" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tf_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    mkdir -p /var/www/html/Mobile
    rm -f /var/www/html/index.html
    echo "THIS IS MOBILE SERVER" > /var/www/html/Mobile/index.html
    systemctl enable --now nginx
  EOF

  tags = {
    Name = "mobile-server"
  }
}


# Target Groups
resource "aws_lb_target_group" "home_tg" {
  name     = "home-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.test-tag.id

  health_check {
    path                = "/"
    matcher             = "200-399"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 5
  }

  tags = {
    Name = "home-tg"
  }
}

resource "aws_lb_target_group" "laptop_tg" {
  name     = "laptop-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.test-tag.id

  health_check {
    path = "/"
  }

  tags = {
    Name = "laptop-tg"
  }
}

resource "aws_lb_target_group" "mobile_tg" {
  name     = "mobile-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.test-tag.id

  health_check {
    path = "/"
  }

  tags = {
    Name = "mobile-tg"
  }
}


# Attach each EC2 to its target group
resource "aws_lb_target_group_attachment" "home_attachment" {
  target_group_arn = aws_lb_target_group.home_tg.arn
  target_id        = aws_instance.home.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "laptop_attachment" {
  target_group_arn = aws_lb_target_group.laptop_tg.arn
  target_id        = aws_instance.laptop.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "mobile_attachment" {
  target_group_arn = aws_lb_target_group.mobile_tg.arn
  target_id        = aws_instance.mobile.id
  port             = 80
}


# Application Load Balancer
resource "aws_lb" "lb" {
  name               = "terraform-app-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.all.ids
  security_groups    = [aws_security_group.tf_sg.id]

  enable_deletion_protection = false

  tags = {
    Name = "terraform-app-alb"
  }
}


# Listener: default route
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.home_tg.arn
  }
}


# Route /home to EC2-1
resource "aws_lb_listener_rule" "home_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.home_tg.arn
  }

  condition {
    path_pattern {
      values = ["/home", "/home/*"]
    }
  }
}


# Route /laptop to EC2-2
resource "aws_lb_listener_rule" "laptop_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.laptop_tg.arn
  }

  condition {
    path_pattern {
      values = ["/laptop", "/laptop/*"]
    }
  }
}


# Route /Mobile to EC2-3
resource "aws_lb_listener_rule" "mobile_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 30

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mobile_tg.arn
  }

  condition {
    path_pattern {
      values = ["/Mobile", "/Mobile/*"]
    }
  }
}
