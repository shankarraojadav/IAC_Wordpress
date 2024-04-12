resource "aws_launch_template" "wordpress" {
  name_prefix = "wordpress"
  image_id = data.aws_ami.wordpress_ami.image_id
  instance_type = "t2.medium"
  user_data = base64encode(templatefile("./wordpress_install.sh", {}))
   network_interfaces {
    device_index              = 0
    subnet_id                 = aws_subnet.public.id
    security_groups           = [aws_security_group.web_server.id]
    associate_public_ip_address = true  # Ensure that instances get public IP addresses
  }
}
