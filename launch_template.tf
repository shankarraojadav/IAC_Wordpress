
resource "aws_launch_template" "wordpress" {
  name_prefix = "wordpress"
  image_id = data.aws_ami.ubuntu.image_id
  instance_type = "t2.medium"
  user_data = base64encode(templatefile("./wordpress_install.sh", {
    db_endpoint = aws_db_instance.wordpress_db.endpoint
    db_name     = aws_db_instance.wordpress_db.db_name
    db_username = aws_db_instance.wordpress_db.username
    db_password = aws_db_instance.wordpress_db.password
  }))

  network_interfaces {
    device_index              = 0
    subnet_id                 = aws_subnet.public.id
    security_groups           = [aws_security_group.web_server.id]
    associate_public_ip_address = true
  }
}
