# VPC

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"


  tags = {
    Name = "Main_VPC"
  }
}

# Subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.aws_zones.names[0]
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.aws_zones.names[1]
}


resource "aws_security_group" "web_server" {
  name = "web_server-sg"
  description = "Security group for web servers"

  vpc_id = aws_vpc.main.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }# Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}


#Creating Route Table
resource "aws_route_table" "route" {
    vpc_id = aws_vpc.main.id
    
    tags = {
        Name = "Route to internet"
    }
}

resource "aws_route_table_association" "rt1" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.route.id
}

resource "aws_route_table_association" "rt2" {
    subnet_id = aws_subnet.private
    route_table_id = aws_route_table.route.id
}


