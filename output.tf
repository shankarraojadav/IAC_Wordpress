output "aws_ami" {
  value = data.aws_ami.wordpress_ami.id
}