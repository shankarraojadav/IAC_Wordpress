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
    security_groups           = [aws_security_group.web_server.id]
    associate_public_ip_address = true
  }
}
