resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "terraform-grocerymate-vpc"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "terraform-grocerymate-igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.public_subnet_az

  tags = {
    Name = "terraform-grocerymate-public-subnet"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "terraform-grocerymate-public-rt"
  }
}
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "ec2_sg" {
  name        = "terraform-grocerymate-ec2-sg"
  description = "Allow SSH and Flask traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["92.208.184.102/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "grocerymate-ec2-sg"
  }
}

resource "aws_instance" "grocerymate_ec2" {

  ami                         = var.aws_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name

  tags = {
    Name      = "terraform-grocerymate-ec2"
    Project   = "grocerymate"
    ManagedBy = "Terraform"
  }
}


resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.private_subnet_1_az

  tags = {
    Name = "terraform-grocerymate-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.private_subnet_2_az

  tags = {
    Name = "terraform-grocerymate-private-subnet-2"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "terraform-grocerymate-rds-sg"
  description = "Allow PostgreSQL traffic from EC2 only"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description     = "PostgreSQL from EC2"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-grocerymate-rds-sg"
  }
}

resource "aws_db_subnet_group" "grocerymate_db_subnet_group" {
  name = "terraform-grocerymate-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Name = "terraform-grocerymate-db-subnet-group"
  }
}

resource "aws_db_instance" "grocerymate_rds" {
  identifier = "terraform-grocerymate-rds"

  engine         = "postgres"
  engine_version = "17"

  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.grocerymate_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false

  skip_final_snapshot = true

  tags = {
    Name      = "terraform-grocerymate-rds"
    Project   = "grocerymate"
    ManagedBy = "Terraform"
  }
}