variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "grocerymate"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "development"
}

variable "managed_by" {
  description = "Managed by tag value"
  type        = string
  default     = "Terraform"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "terraform-grocerymate-vpc"
}

variable "igw_name" {
  description = "Internet Gateway name"
  type        = string
  default     = "terraform-grocerymate-igw"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_az" {
  description = "Public subnet availability zone"
  type        = string
  default     = "eu-north-1a"
}

variable "public_subnet_name" {
  description = "Public subnet name"
  type        = string
  default     = "terraform-grocerymate-public-subnet"
}

variable "private_subnet_1_cidr" {
  description = "Private subnet 1 CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_2_cidr" {
  description = "Private subnet 2 CIDR"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_1_az" {
  description = "Private subnet 1 availability zone"
  type        = string
  default     = "eu-north-1a"
}

variable "private_subnet_2_az" {
  description = "Private subnet 2 availability zone"
  type        = string
  default     = "eu-north-1b"
}

variable "private_subnet_1_name" {
  description = "Private subnet 1 name"
  type        = string
  default     = "terraform-grocerymate-private-subnet-1"
}

variable "private_subnet_2_name" {
  description = "Private subnet 2 name"
  type        = string
  default     = "terraform-grocerymate-private-subnet-2"
}

variable "default_route_cidr" {
  description = "Default route CIDR"
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_route_table_name" {
  description = "Public route table name"
  type        = string
  default     = "terraform-grocerymate-public-rt"
}

variable "aws_ami" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0cc0615fa97a31072"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Whether EC2 receives a public IP"
  type        = bool
  default     = true
}

variable "ec2_name" {
  description = "EC2 instance name"
  type        = string
  default     = "terraform-grocerymate-ec2"
}

variable "ec2_security_group_name" {
  description = "EC2 security group name"
  type        = string
  default     = "terraform-grocerymate-ec2-sg"
}

variable "ec2_security_group_description" {
  description = "EC2 security group description"
  type        = string
  default     = "Allow SSH and Flask traffic"
}

variable "ec2_security_group_tag_name" {
  description = "EC2 security group tag name"
  type        = string
  default     = "grocerymate-ec2-sg"
}

variable "http_ingress_description" {
  description = "HTTP ingress description"
  type        = string
  default     = "HTTP"
}

variable "ssh_ingress_description" {
  description = "SSH ingress description"
  type        = string
  default     = "SSH"
}

variable "egress_description" {
  description = "Egress description"
  type        = string
  default     = "Allow all outbound traffic"
}

variable "http_port" {
  description = "HTTP port"
  type        = number
  default     = 80
}

variable "http_cidr" {
  description = "Allowed CIDR for HTTP"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}

variable "ssh_cidr" {
  description = "Public IPv4 address allowed to connect through SSH"
  type        = string
  default     = "92.208.184.102/32"
}

variable "tcp_protocol" {
  description = "TCP protocol"
  type        = string
  default     = "tcp"
}

variable "all_traffic_protocol" {
  description = "Protocol value for all traffic"
  type        = string
  default     = "-1"
}

variable "all_traffic_port" {
  description = "Port value for all traffic"
  type        = number
  default     = 0
}

variable "rds_security_group_name" {
  description = "RDS security group name"
  type        = string
  default     = "terraform-grocerymate-rds-sg"
}

variable "rds_security_group_description" {
  description = "RDS security group description"
  type        = string
  default     = "Allow PostgreSQL traffic from EC2 only"
}

variable "rds_security_group_tag_name" {
  description = "RDS security group tag name"
  type        = string
  default     = "terraform-grocerymate-rds-sg"
}

variable "postgres_ingress_description" {
  description = "PostgreSQL ingress description"
  type        = string
  default     = "PostgreSQL from EC2"
}

variable "db_subnet_group_name" {
  description = "DB subnet group name"
  type        = string
  default     = "terraform-grocerymate-db-subnet-group"
}

variable "db_subnet_group_tag_name" {
  description = "DB subnet group tag name"
  type        = string
  default     = "terraform-grocerymate-db-subnet-group"
}

variable "rds_identifier" {
  description = "RDS identifier"
  type        = string
  default     = "terraform-grocerymate-rds"
}

variable "rds_name" {
  description = "RDS name tag"
  type        = string
  default     = "terraform-grocerymate-rds"
}

variable "rds_engine" {
  description = "RDS database engine"
  type        = string
  default     = "postgres"
}

variable "rds_engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "17"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "rds_storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp3"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "grocerymate"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "groceryadmin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "rds_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}

variable "rds_publicly_accessible" {
  description = "Whether RDS is publicly accessible"
  type        = bool
  default     = false
}

variable "rds_skip_final_snapshot" {
  description = "Whether to skip final RDS snapshot"
  type        = bool
  default     = true
}

variable "s3_full_access_policy_arn" {
  description = "AWS managed AmazonS3FullAccess policy ARN"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
variable "alert_email" {
  description = "Email address for CloudWatch alerts"
  type        = string
}