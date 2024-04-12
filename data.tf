data "aws_availability_zones" "aws_zones" {
  state = "available"
}

# aws_ami

data "aws_ami" "wordpress_ami" {
  executable_users = ["self"]
  most_recent      = true
  name_regex       = "^myami-\\d{3}"
  owners           = ["self"]


  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}