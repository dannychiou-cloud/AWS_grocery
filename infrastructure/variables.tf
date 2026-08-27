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