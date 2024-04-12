resource "aws_rds_cluster" "db_cluster" {
  engine                 = "mysql"  
  engine_version         = "8.0"  
  cluster_identifier     = "my-wordpress-cluster"
  database_name          = "wordpress"
  master_username        = "admin"
  master_password        = ""
  skip_final_snapshot     = true

  
  availability_zones     = data.aws_availability_zones.aws_zones.names

}


resource "aws_rds_cluster_role_association" "rds_access_role" {
  db_cluster_identifier = aws_rds_cluster.db_cluster.id
  feature_name          = "S3_INTEGRATION"
  role_arn              = aws_iam_role.db_access_role.arn
}

resource "aws_iam_role" "db_access_role" {
  name = "db_access_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "db_access_policy" {
  role       = aws_iam_role.db_access_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"  
}

