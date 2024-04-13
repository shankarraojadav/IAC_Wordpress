
resource "aws_launch_template" "wordpress" {
  name_prefix = "wordpress"
  image_id = data.aws_ami.ubuntu.image_id
  instance_type = "t2.large"
   user_data = base64encode(templatefile("./wordpress_install.sh", {
    db_endpoint = aws_db_instance.wordpress_db.endpoint
    db_name     = aws_db_instance.wordpress_db.db_name
    db_username = aws_db_instance.wordpress_db.username
    db_password = aws_db_instance.wordpress_db.password
  }))

  depends_on = [aws_db_instance.wordpress_db]

 block_device_mappings {
    device_name = "/dev/sda1"  # Device name for the root volume
    ebs {
      volume_size = 30          # Size of the root volume in GB
      volume_type = "gp2"       # Volume type (e.g., gp2, io1)
      delete_on_termination = true  # Delete the volume when the instance terminates
    }
  }

   monitoring {
    enabled = true
  }

  # Configure Instance Metadata Service v2
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  network_interfaces {
    device_index              = 0
    subnet_id                 = aws_subnet.public.id
    security_groups           = [aws_security_group.SG_for_EC2.id]
    associate_public_ip_address = true
  }
}



resource "aws_security_group" "SG_for_EC2" {
  name        = "SG_for_EC2"
  description = "Allow 80, 443, 22 port inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "Custom port 8000"
    from_port   = 8000
    to_port     = 8000
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
