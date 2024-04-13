resource "aws_db_instance" "wordpress_db" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name                            = var.rds_credentials.dbname
  username                        = var.rds_credentials.username
  password                        = var.rds_credentials.password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
 #  vpc_security_group_ids = [aws_security_group.SG_for_RDS.id]
  depends_on                      = [aws_security_group.SG_for_RDS]

}

resource "aws_security_group" "SG_for_RDS" {
  name        = "SG_for_RDS"
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "RDS from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.SG_for_EC2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   depends_on = [aws_security_group.SG_for_EC2]
}
