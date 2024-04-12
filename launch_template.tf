resource "aws_launch_template" "wordpress" {
  name_prefix = "wordpress"
  image_id = data.aws_ami.wordpress_ami.image_id
  instance_type = t2.medium
  user_data = templatefile("./wordpress_install.sh", {})
}