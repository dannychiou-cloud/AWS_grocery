variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Name used when tagging GroceryMate AWS resources"
  type        = string
  default     = "grocerymate"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "development"
}

variable "ssh_cidr" {
  description = "Public IPv4 address allowed to connect through SSH"
  type        = string
}

variable "key_name" {
  description = "Name of an existing EC2 key pair"
  type        = string
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "public_subnet_cidr" {
  description = "Public subnet for EC2"
  type        = string
  default     = "10.0.1.0/24"
}
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnet_az" {
  description = "public subnet az"
  type        = string
  default     = "eu-north-1a"
}
variable "aws_ami" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0cc0615fa97a31072"
}

variable "private_subnet_1_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_subnet_2_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

variable "private_subnet_1_az" {
  type    = string
  default = "eu-north-1a"
}

variable "private_subnet_2_az" {
  type    = string
  default = "eu-north-1b"
}

variable "db_name" {
  type    = string
  default = "grocerymate"
}

variable "db_username" {
  type    = string
  default = "groceryadmin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

