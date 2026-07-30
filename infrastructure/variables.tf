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

variable "public_subnet_id" {
  description = "Public subnet for EC2"
  type        = string
}