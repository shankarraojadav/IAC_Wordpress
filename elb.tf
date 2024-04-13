
resource "aws_security_group" "word_sg" {
  name        = "Demo Security Group"
  description = "Demo Module"
  vpc_id      = aws_vpc.main.id

  # HTTP access from anywhere (Consider restricting for better security)
  ingress {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port  = 443
    to_port    = 443
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from anywhere (Consider restricting for better security)
  ingress {
    from_port  = 22
    to_port    = 22
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a new load balancer
resource "aws_elb" "web_elb" {
  name        = "foobar-terraform-elb"
  subnets     = [aws_subnet.private.id, aws_subnet.public.id]
  security_groups = [aws_security_group.word_sg.id]

  listener {
    instance_port  = 8000
    instance_protocol = "http"
    lb_port        = 443
    lb_protocol    = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  # Use the Auto Scaling Group for instances (reference by name)
  #instances = aws_autoscaling_group.aws_asg.name

  cross_zone_load_balancing = true
  idle_timeout              = 400
  connection_draining       = true
  connection_draining_timeout = 400

  tags = {
    Name = "wordpress-terraform-elb"
  }
}
