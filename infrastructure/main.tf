resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.public_subnet_az

  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.default_route_cidr
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "ec2_sg" {
  name        = var.ec2_security_group_name
  description = var.ec2_security_group_description
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = var.http_ingress_description
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.tcp_protocol
    cidr_blocks = [var.http_cidr]
  }

  ingress {
    description = var.ssh_ingress_description
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.tcp_protocol
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    description = var.egress_description
    from_port   = var.all_traffic_port
    to_port     = var.all_traffic_port
    protocol    = var.all_traffic_protocol
    cidr_blocks = [var.default_route_cidr]
  }

  tags = {
    Name = var.ec2_security_group_tag_name
  }
}

resource "aws_instance" "grocerymate_ec2" {
  ami                         = var.aws_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = var.associate_public_ip_address

  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name

  tags = {
    Name      = var.ec2_name
    Project   = var.project_name
    ManagedBy = var.managed_by
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.private_subnet_1_az

  tags = {
    Name = var.private_subnet_1_name
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.private_subnet_2_az

  tags = {
    Name = var.private_subnet_2_name
  }
}

resource "aws_security_group" "rds_sg" {
  name        = var.rds_security_group_name
  description = var.rds_security_group_description
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description     = var.postgres_ingress_description
    from_port       = var.rds_port
    to_port         = var.rds_port
    protocol        = var.tcp_protocol
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = var.all_traffic_port
    to_port     = var.all_traffic_port
    protocol    = var.all_traffic_protocol
    cidr_blocks = [var.default_route_cidr]
  }

  tags = {
    Name = var.rds_security_group_tag_name
  }
}

resource "aws_db_subnet_group" "grocerymate_db_subnet_group" {
  name = var.db_subnet_group_name

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Name = var.db_subnet_group_tag_name
  }
}

resource "aws_db_instance" "grocerymate_rds" {
  identifier = var.rds_identifier

  engine         = var.rds_engine
  engine_version = var.rds_engine_version

  instance_class    = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage
  storage_type      = var.rds_storage_type

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.rds_port

  db_subnet_group_name   = aws_db_subnet_group.grocerymate_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = var.rds_publicly_accessible
  skip_final_snapshot = var.rds_skip_final_snapshot

  tags = {
    Name      = var.rds_name
    Project   = var.project_name
    ManagedBy = var.managed_by
  }
}