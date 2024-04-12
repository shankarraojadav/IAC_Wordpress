data "aws_availability_zones" "aws_zones" {
  state = "available"
}

# aws_ami

data "aws_ami" "wordpress_ami" {

  most_recent      = true

}
