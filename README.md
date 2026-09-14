GroceryMate ☁️
A cloud-based GroceryMate application deployed using AWS, Terraform, Docker, and PostgreSQL.

This project was created as part of my Cloud Engineering learning path. The main focus is the AWS architecture, how the services work together, and how the infrastructure is managed with Terraform.
<img width="1672" height="941" alt="project diagram" src="https://github.com/user-attachments/assets/58323404-abe8-490d-a199-601ee22c569a" />


📌 Table of Contents

Project Overview

Architecture

AWS Services Used

Where to Find Things

Terraform

Terraform Deployment

Docker and Environment Variables

Security

CloudWatch Monitoring

AWS Cost Evaluation

Future Improvements

Author

📖 Project Overview

GroceryMate is a cloud engineering project that demonstrates how a containerized application can run on AWS.

The application runs on Amazon EC2, uses Amazon RDS PostgreSQL as its database, and uses Amazon S3 for object storage such as avatar files.

The AWS infrastructure is created and managed with Terraform.

Main technologies used:

AWS

Terraform

Docker

Python / Flask

PostgreSQL

Git & GitHub

🏗️ Architecture

The application runs inside a custom AWS VPC.



How the main components work together

A user connects to the GroceryMate application running on EC2.

The Internet Gateway provides internet connectivity to the public subnet.

EC2 connects to RDS PostgreSQL on port 5432.

RDS is private and accepts database traffic only from the EC2 Security Group.

EC2 accesses S3 through an IAM Role instead of hardcoded AWS credentials.

Terraform is used to provision and manage the infrastructure.

The architecture keeps the application reachable while the database remains private.

☁️ AWS Services Used

Service

Purpose

Amazon EC2

Runs the Dockerized GroceryMate application

Amazon RDS PostgreSQL

Stores application data in a managed database

Amazon S3

Stores objects such as avatar files

Amazon VPC

Provides the network for the project

Public + Private Subnets

Separate the public application from the private database

Internet Gateway

Gives the public subnet internet connectivity

Route Table

Routes public subnet traffic to the Internet Gateway

IAM Role / Instance Profile

Gives EC2 permission to access AWS services

Security Groups

Control network access to EC2 and RDS

Amazon CloudWatch

Monitors AWS resources and provides alarms

📂 Where to Find Things

File / Location

What it is for

main.tf

Main Terraform infrastructure configuration

variables.tf

Defines the variables used by Terraform

terraform.tfvars

Stores the values supplied to the Terraform variables

Dockerfile

Instructions for building the GroceryMate Docker image

.env

Local application environment variables

.gitignore

Prevents local or sensitive files from being committed

README.md

Project documentation

docs/

Architecture diagrams and project images

Sensitive values such as passwords should not be committed to GitHub.

🛠️ Terraform

Terraform is used to create and manage the AWS infrastructure.

main.tf

main.tf contains the main infrastructure configuration.

It defines resources such as the VPC, subnets, EC2, RDS, S3, IAM, routing, and Security Groups.

Instead of hardcoding every value, the resources can reference Terraform variables.

Example:

cidr_block = var.vpc_cidr

variables.tf

variables.tf defines the variables that Terraform expects.

Example:

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

The actual values are provided separately, for example in terraform.tfvars.

This makes the infrastructure easier to change and reuse.

🚀 Terraform Deployment

The project uses the standard Terraform workflow:

1. Initialize

terraform init

Prepares Terraform and downloads the required provider.

2. Format

terraform fmt

Formats the Terraform files.

3. Validate

terraform validate

Checks the Terraform configuration.

4. Review the Plan

terraform plan

Shows what Terraform will create, change, or remove.

5. Deploy

terraform apply

Creates or updates the AWS infrastructure.

6. Remove the Environment

terraform destroy

Deletes the Terraform-managed AWS resources when they are no longer needed.

This is especially useful in a learning environment because it helps avoid unnecessary AWS costs.

🐳 Docker and Environment Variables

The GroceryMate application is containerized with Docker.

The Dockerfile contains the instructions used to build the application image.

Build the image

docker build -t grocerymate .

Run the container

docker run --env-file .env grocerymate

.env

Application settings are passed through environment variables instead of being hardcoded inside the application.

The .env file can contain values such as:

DB_HOST=...
DB_NAME=...
DB_USER=...
DB_PASSWORD=...

The .env file should be kept out of GitHub when it contains passwords or other sensitive values.

A .env.example file can be used to show which variables are required without exposing real credentials.

🔐 Security

The project uses a few simple security controls:

RDS is private with publicly_accessible = false.

Port 5432 is allowed to RDS only from the EC2 Security Group.

S3 Block Public Access is enabled.

S3 Versioning is enabled.

EC2 uses an IAM Role to access S3 instead of hardcoded AWS keys.

SSH access is restricted using the configured ssh_cidr.

Sensitive local files such as .env and terraform.tfvars should not be committed when they contain secrets.

📈 CloudWatch Monitoring

Amazon CloudWatch is used to monitor the AWS environment.

The main focus is on infrastructure health, for example:

EC2 CPU utilization

EC2 instance health/status

RDS performance and database health

A CloudWatch alarm is used to watch EC2 CPU utilization and trigger when the configured threshold is exceeded.

CloudWatch makes it easier to notice unusual resource usage or problems without constantly checking the AWS Console.

An SNS email notification can be connected to an alarm for email alerts.

📊 AWS Cost Evaluation

The main project costs come from EC2, RDS, S3, and data transfer.

Service

Main Cost Factor

Cost Approach

EC2

Instance running time

Use a small instance and run it only when needed

RDS

DB running time and storage

Use a small database instance for development

S3

Storage and requests

Low cost for a small amount of project data

Data Transfer

Amount of transferred data

Keep unnecessary transfer low

VPC / Security Groups / IAM

No normal hourly resource charge

Used mainly for networking and security

For this development project, one of the most important cost-control steps is:

terraform destroy

when the infrastructure is no longer required.

🚀 Future Improvements

Possible future improvements include:

Application Load Balancer

HTTPS with AWS Certificate Manager

Route 53

Auto Scaling

CI/CD deployment

AWS Secrets Manager

Remote Terraform state

Additional monitoring and alerting

👤 Author

Danny Chiou
Cloud Engineering Student

Technologies Practiced

AWS • Terraform • Docker • EC2 • RDS • S3 • IAM • VPC • PostgreSQL • Python • Flask • Git • GitHub


