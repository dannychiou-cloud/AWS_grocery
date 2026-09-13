# GroceryMate

<img width="1672" height="941" alt="AWS Architechture Danny Chiou" src="https://github.com/user-attachments/assets/1e997453-4921-4717-81d8-5c598bd28c69" />

A cloud-based GroceryMate application deployed using **AWS**, **Terraform**, **Docker**, and **PostgreSQL**.

This project was created as part of my Cloud Engineering learning path and demonstrates how a containerized application can be deployed on AWS using Infrastructure as Code.

---

## 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Architecture](#️-architecture)
- [Technologies Used](#️-technologies-used)
- [AWS Services Used](#️-aws-services-used)
- [1. Amazon EC2](#1-amazon-ec2)
- [2. Amazon RDS PostgreSQL](#2-amazon-rds-postgresql)
- [3. Amazon S3](#3-amazon-s3)
- [4. Amazon VPC](#4-amazon-vpc)
- [5. Internet Gateway and Routing](#5-internet-gateway-and-routing)
- [6. IAM Role and Instance Profile](#6-iam-role-and-instance-profile)
- [7. Security Groups](#7-security-groups)
- [Infrastructure as Code - Terraform](#infrastructure-as-code---terraform)
- [Terraform Files](#terraform-files)
- [Terraform Deployment Process](#terraform-deployment-process)
- [Docker Deployment](#docker-deployment)
- [Application Workflow](#application-workflow)
- [Security Implementation](#security-implementation)
- [AWS Cost Evaluation](#-aws-cost-evaluation)
- [Challenges & Solutions](#-challenges--solutions)
- [What I Learned](#-what-i-learned)
- [Future Improvements](#-future-improvements)
- [Author](#-author)

# 📖 Project Overview

**GroceryMate** is a cloud engineering project designed to demonstrate how a backend application can be deployed and managed using Amazon Web Services.

The application is containerized using Docker and hosted on an Amazon EC2 instance.

Amazon RDS PostgreSQL provides the relational database, while Amazon S3 is used for object storage such as application files and avatar images.

The AWS infrastructure is provisioned using Terraform.

The project demonstrates:

- Infrastructure as Code using Terraform
- Amazon VPC networking
- Public and private subnets
- Amazon EC2 compute
- Docker containerization
- Amazon RDS PostgreSQL
- Private database networking
- Amazon S3 object storage
- S3 Versioning
- S3 Block Public Access
- IAM Roles
- IAM Instance Profiles
- Security Groups
- Terraform variables
- Terraform deployment and destruction
- Git and GitHub version control

The GroceryMate application runs on an Amazon EC2 instance inside a custom Amazon VPC.

The architecture contains:

- One custom VPC
- One public subnet for EC2
- Two private subnets for Amazon RDS
- An Internet Gateway
- A public route table
- An EC2 Security Group
- An RDS Security Group
- Amazon RDS PostgreSQL
- Amazon S3
- An IAM Role
- An IAM Instance Profile
- Docker
- Terraform

### High-Level Architecture
<img width="1672" height="941" alt="AWS Architechture Danny Chiou" src="https://github.com/user-attachments/assets/d2fe0782-26f9-4da6-a948-d66c1f5d8a07" />

The EC2 instance acts as the application server.

The EC2 application communicates with:

- Amazon RDS over PostgreSQL port **5432**
- Amazon S3 using permissions provided through an IAM Role

The RDS database is not directly accessible from the public internet.


# 🛠️ Technologies Used

| Category | Technology |
|---|---|
| Cloud Provider | AWS |
| Infrastructure as Code | Terraform |
| Compute | Amazon EC2 |
| Database | Amazon RDS PostgreSQL |
| Object Storage | Amazon S3 |
| Networking | Amazon VPC |
| Identity & Permissions | AWS IAM |
| Containerization | Docker |
| Backend | Python / Flask |
| Database | PostgreSQL |
| Version Control | Git & GitHub |
| Operating System | Amazon Linux |

# ☁️ AWS Services Used

| AWS Service | Purpose |
|---|---|
| Amazon EC2 | Hosts the GroceryMate application |
| Amazon RDS PostgreSQL | Provides the managed relational database |
| Amazon S3 | Stores application objects such as avatar files |
| Amazon VPC | Provides an isolated network environment |
| Internet Gateway | Provides internet connectivity to the public subnet |
| IAM | Gives EC2 permission to interact with AWS services |
| Security Groups | Control inbound and outbound network traffic |

Terraform is used to create and manage these resources.

# 1. Amazon EC2

## Purpose

Amazon EC2 provides the compute environment where the GroceryMate backend application runs.

The application is containerized using Docker and deployed on the EC2 instance.

## Configuration

The EC2 instance is:

- Deployed inside the GroceryMate VPC
- Located inside the public subnet
- Protected by an EC2 Security Group
- Connected to an IAM Instance Profile
- Used to run the Dockerized GroceryMate application
- Able to communicate with Amazon RDS
- Able to access Amazon S3 through IAM permissions

## Internet Access

The EC2 instance is located in a public subnet.

The public subnet is connected to an Internet Gateway through a route table.

<img width="476" height="601" alt="diagram ec2" src="https://github.com/user-attachments/assets/7391b25a-3ac7-405b-abb9-f2c50f321610" />


HTTP access is used to reach the application.

SSH access is restricted through a configurable CIDR value instead of being unrestricted.

---

# 2. Amazon RDS PostgreSQL

## Purpose

Amazon RDS provides the managed PostgreSQL database used by GroceryMate.

The database stores application data and is provisioned using Terraform.

## Private Database Design

The RDS database is configured as:

```hcl
publicly_accessible = false
```

This means that the database cannot be directly accessed from the public internet.

Instead, the GroceryMate EC2 instance communicates with the database internally through the VPC.

## DB Subnet Group

Amazon RDS uses a DB Subnet Group containing two private subnets.

<img width="1448" height="1086" alt="vpc diagram" src="https://github.com/user-attachments/assets/7e144470-0ba9-43bb-bca0-cb831b4fbb81" />

Using two subnets allows the RDS DB Subnet Group to span multiple Availability Zones.

## Database Access

The database uses PostgreSQL port:

```text
5432
```

The RDS Security Group allows port **5432 only from the EC2 Security Group**.

<img width="1448" height="1086" alt="ec2diagram postgres" src="https://github.com/user-attachments/assets/cd60f1d8-d5c6-499d-bfe5-0ebe3735ee0f" />


This prevents external clients from directly connecting to the database.

---

# 3. Amazon S3

## Purpose

Amazon S3 provides object storage for the GroceryMate application.

It can be used to store objects such as user avatar images and other application files.

## Versioning

S3 Versioning is enabled.

Versioning allows previous versions of objects to be retained if files are changed or replaced.

## Block Public Access

S3 Block Public Access is enabled.

The following protections are configured:

```text
block_public_acls
block_public_policy
ignore_public_acls
restrict_public_buckets
```

This prevents the S3 bucket from becoming publicly accessible.

## EC2 Access to S3

The EC2 instance accesses Amazon S3 using an IAM Role.

The application therefore does not need AWS access keys hardcoded inside the application.

The project includes permissions for operations such as:

```text
s3:ListBucket
s3:GetObject
s3:PutObject
```

During the learning project, broad S3 permissions were also tested.

For a production environment, a more restrictive least-privilege IAM policy should be used so the EC2 instance receives only the permissions it requires.

---

# 4. Amazon VPC

## Purpose

Amazon VPC provides the isolated networking environment for the GroceryMate AWS infrastructure.

The project uses a custom VPC instead of relying only on the AWS default VPC.

The network contains:

<img width="806" height="527" alt="vpc diagram3" src="https://github.com/user-attachments/assets/32d05a14-03a5-4c1d-a95e-389191700eed" />


Terraform is used to provision the VPC and its networking components.

## Terraform Variables

Network values are defined using Terraform variables instead of placing every value directly inside the resources.

Examples include:

```text
VPC CIDR
Public Subnet CIDR
Private Subnet CIDRs
AWS Region
Availability Zones
```

This makes the Terraform configuration easier to change and reuse.

---

# 5. Internet Gateway and Routing

## Internet Gateway

An Internet Gateway is attached to the VPC.

Its purpose is to provide internet connectivity to resources inside the public subnet.

## Route Table

A public route table contains a default route to the Internet Gateway.

Conceptually:

```text
0.0.0.0/0
     │
     ▼
Internet Gateway
```

The public subnet is associated with this route table.

The EC2 instance is located in the public subnet.

The private RDS subnets are used for the database and do not expose RDS directly to the internet.

---

# 6. IAM Role and Instance Profile

## Purpose

IAM controls which AWS services the EC2 instance is allowed to access.

Instead of putting AWS access keys inside the GroceryMate application, an IAM Role is used.

The role is attached to the EC2 instance through an IAM Instance Profile.

```text
EC2
 │
 ▼
IAM Instance Profile
 │
 ▼
IAM Role
 │
 ▼
AWS Permissions
 │
 ▼
Amazon S3
```

This is safer than storing AWS credentials inside application code.

## S3 Access

The EC2 IAM configuration allows the application to communicate with the S3 bucket.

Relevant actions include:

```text
s3:ListBucket
s3:GetObject
s3:PutObject
```

The IAM Role allows the application running on EC2 to request temporary AWS credentials automatically.

---

# 7. Security Groups

Security Groups act as virtual firewalls around AWS resources.

Two main Security Groups are used in the project:

- EC2 Security Group
- RDS Security Group

## EC2 Security Group

The EC2 Security Group controls incoming traffic to the application server.

It allows the required application traffic.

SSH access is restricted using the Terraform `ssh_cidr` variable.

This is safer than allowing SSH access from:

```text
0.0.0.0/0
```

## RDS Security Group

The RDS Security Group allows:

| Port | Source | Purpose |
|---|---|---|
| 5432 | EC2 Security Group | PostgreSQL database connection |

The source is the **EC2 Security Group**, not the entire internet.

This means:

```text
Internet  ✖  RDS

EC2       ✔  RDS : 5432
```

This is one of the main security improvements implemented during the project.

---

# Infrastructure as Code - Terraform

Terraform is used to provision and manage the AWS infrastructure.

Instead of manually creating every AWS resource in the AWS Console, the infrastructure is defined as code.

Terraform manages resources including:

- VPC
- Internet Gateway
- Public Subnet
- Private RDS Subnets
- Route Table
- Route Table Association
- Security Groups
- EC2
- RDS
- RDS DB Subnet Group
- S3
- IAM Role
- IAM Instance Profile

Benefits of Terraform include:

- Repeatable infrastructure
- Consistent deployments
- Infrastructure stored as code
- Easier modification
- Easier cleanup
- Version control with Git

---

# Terraform Files

The Terraform project uses multiple files to separate configuration from values.

Important files include:

```text
main.tf
variables.tf
terraform.tfvars
outputs.tf
```

Additional `.tf` files may be used to organize specific AWS resources.

---

## main.tf

`main.tf` contains the Terraform resources that create the AWS infrastructure.

For example:

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}
```

Instead of hardcoding the CIDR value, the resource references:

```hcl
var.vpc_cidr
```

---

## variables.tf

`variables.tf` defines which configurable values Terraform expects.

Example:

```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
}
```

Another example:

```hcl
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
```

The variable definitions do not necessarily contain the final project values.

They describe the values Terraform expects.

---

## terraform.tfvars

`terraform.tfvars` provides the actual values for the Terraform variables.

Example:

```hcl
aws_region = "eu-central-1"

vpc_cidr = "10.0.0.0/16"
```

Terraform automatically reads these values and makes them available through:

```hcl
var.aws_region
var.vpc_cidr
```

The relationship is:

```text
variables.tf
     │
     │ defines variables
     ▼
terraform.tfvars
     │
     │ provides values
     ▼
Terraform Resources
     │
     ▼
AWS Infrastructure
```

Sensitive values such as passwords should not be committed to GitHub.

If `terraform.tfvars` contains credentials or passwords, it should be excluded using `.gitignore`.

---

## outputs.tf

Terraform outputs can display useful information after deployment.

Examples could include:

```text
EC2 public IP
EC2 instance ID
RDS endpoint
S3 bucket name
```

Outputs make it easier to retrieve important information from Terraform after the deployment.

---

# Terraform Deployment Process

The infrastructure was created and tested using the standard Terraform workflow.

---

## 1. Initialize Terraform

```bash
terraform init
```

`terraform init` initializes the Terraform working directory and downloads the required AWS provider.

---

## 2. Format Terraform

```bash
terraform fmt
```

Formats Terraform files according to Terraform formatting standards.

---

## 3. Validate Terraform

```bash
terraform validate
```

Checks whether the Terraform configuration is syntactically valid.

---

## 4. Review the Terraform Plan

```bash
terraform plan
```

Displays which AWS resources Terraform intends to:

- Create
- Modify
- Destroy

This allows changes to be reviewed before deployment.

---

## 5. Deploy the Infrastructure

```bash
terraform apply
```

Terraform creates the AWS resources defined in the configuration.

---

## 6. Verify the Infrastructure

After deployment, the AWS resources can be checked through:

- AWS Console
- Terraform outputs
- Application testing

Important checks include:

- EC2 availability
- RDS private configuration
- Security Group rules
- S3 configuration
- IAM Role attachment

---

## 7. Destroy the Infrastructure

```bash
terraform destroy
```

Terraform removes the AWS resources managed by the configuration.

This is particularly useful for development and learning environments because resources do not need to remain active when they are not being used.

Destroying unused resources also helps reduce AWS costs.

---

# Docker Deployment

The GroceryMate backend application is containerized using Docker.

Docker packages the application together with the dependencies required for it to run.

A Docker image can be created using:

```bash
docker build -t grocerymate .
```

The Docker container is then run on the Amazon EC2 instance.

Conceptually:

```text
EC2
 │
 ▼
Docker
 │
 ▼
GroceryMate Application
```

The application can then communicate with:

```text
Amazon RDS
Amazon S3
```

Docker makes the application easier to run consistently across different environments.

---

# Application Workflow

## Normal Application Request

A user accesses the GroceryMate application through the EC2 instance.

```text
User / Browser
      │
      ▼
Internet
      │
      ▼
Internet Gateway
      │
      ▼
EC2
      │
      ▼
Docker Container
      │
      ▼
GroceryMate Application
```

---

## Database Workflow

When GroceryMate needs information from the database:

```text
GroceryMate
     │
     ▼
EC2
     │
     │ PostgreSQL :5432
     ▼
Amazon RDS
```

The database connection remains inside the AWS VPC.

RDS does not need to be publicly accessible.

---

## S3 Workflow

When the application needs to store or retrieve an object:

```text
GroceryMate
     │
     ▼
EC2
     │
     ▼
IAM Role
     │
     ▼
Amazon S3
```

The EC2 instance receives AWS permissions through its IAM Role.

AWS access keys therefore do not need to be stored directly inside the application.

---

# Security Implementation

Security was an important part of the GroceryMate infrastructure.

---

## Network Security

The infrastructure is deployed inside a custom VPC.

The design separates:

```text
Public Application Layer
        │
        ▼
Private Database Layer
```

The EC2 instance is placed in the public subnet.

Amazon RDS is placed inside private subnets.

RDS is configured with:

```hcl
publicly_accessible = false
```

---

## Database Security

PostgreSQL traffic on port **5432** is accepted only from the EC2 Security Group.

```text
EC2 Security Group
       │
       │ TCP 5432
       ▼
RDS Security Group
```

Direct database connections from the public internet are therefore prevented.

---

## S3 Security

Amazon S3 Block Public Access is enabled.

The project enables:

```text
block_public_acls
block_public_policy
ignore_public_acls
restrict_public_buckets
```

S3 Versioning is also enabled.

---

## IAM Security

The EC2 instance uses an IAM Role through an IAM Instance Profile.

This avoids placing permanent AWS credentials directly inside the GroceryMate application.

For a production environment, permissions should follow the **principle of least privilege**.

---

## Terraform Security

Sensitive configuration values should not be stored directly inside Terraform resource definitions.

Variables allow values to be supplied separately.

Files containing secrets should not be committed to GitHub.

---

# 📊 AWS Cost Evaluation

AWS costs were considered as part of the project.

The main services that can generate costs are EC2, RDS, S3, and data transfer.

---

## Amazon EC2

Amazon EC2 is charged mainly based on how long an instance is running and which instance type is used.

For a development project, a small instance type is sufficient.

Cost can be reduced by:

- Using a small instance
- Running the instance only when necessary
- Destroying temporary infrastructure after testing

---

## Amazon RDS

Amazon RDS is likely to be one of the larger costs in this architecture.

RDS pricing depends on factors such as:

- Database instance class
- Running time
- Allocated storage
- Backup storage
- Data transfer

For a learning environment, a small database instance is appropriate.

Destroying the database when the environment is no longer required avoids unnecessary ongoing costs.

---

## Amazon S3

Amazon S3 is generally inexpensive for small projects.

Costs are based mainly on:

- Amount of stored data
- Number of requests
- Data transfer

Avatar images and small application files require relatively little storage.

---

## Amazon VPC

Creating a VPC itself does not create a normal hourly VPC charge.

Resources such as:

- Subnets
- Route Tables
- Security Groups
- Internet Gateway

do not have the same type of hourly compute charge as EC2 or RDS.

Data transfer charges can still apply depending on how traffic moves through AWS.

---

## IAM

IAM Roles, policies, and Instance Profiles do not create a normal additional hourly infrastructure charge.

They are primarily used to control permissions.

---

## Terraform

Terraform itself is used as the Infrastructure as Code tool.

The local Terraform CLI does not create an AWS service charge.

The costs come from the AWS resources that Terraform creates.

---

## Cost Summary

| Component | Main Cost Factor |
|---|---|
| EC2 | Instance running time |
| RDS | DB instance running time and storage |
| S3 | Storage and requests |
| Data Transfer | Amount and direction of transferred data |
| VPC | No normal charge for basic VPC itself |
| Security Groups | No direct charge |
| IAM | No direct charge |
| Terraform CLI | No AWS charge |

For this development environment, the most important cost-control measure is:

```bash
terraform destroy
```

after the infrastructure is no longer required.

This prevents EC2 and RDS resources from continuing to generate costs while the project is not being used.

---

# 🧩 Challenges & Solutions

During the project, several cloud engineering challenges were encountered.

| Challenge | Solution |
|---|---|
| Creating infrastructure manually | Used Terraform Infrastructure as Code |
| Organizing Terraform configuration | Used variables and separate Terraform files |
| Hardcoded configuration values | Moved configurable values into Terraform variables |
| Creating secure database networking | Placed RDS in private subnets |
| Public database exposure | Set `publicly_accessible = false` |
| Database access control | Allowed port 5432 only from the EC2 Security Group |
| RDS subnet requirements | Created two private subnets and a DB Subnet Group |
| Application deployment | Containerized GroceryMate using Docker |
| EC2 access to S3 | Added an IAM Role and Instance Profile |
| Public S3 exposure | Enabled S3 Block Public Access |
| Protecting stored objects | Enabled S3 Versioning |
| Managing infrastructure changes | Used `terraform plan` before `terraform apply` |
| Removing development resources | Used `terraform destroy` |
| Understanding Terraform variables | Used `variables.tf` together with `terraform.tfvars` |

---

# 🎓 What I Learned

This project improved my understanding of how multiple AWS services work together inside one architecture.

## Terraform

I learned that Terraform separates infrastructure logic from configurable values.

```text
variables.tf
     │
     ▼
terraform.tfvars
     │
     ▼
Terraform Resources
     │
     ▼
AWS
```

I also learned the Terraform workflow:

```text
terraform init
       │
       ▼
terraform validate
       │
       ▼
terraform plan
       │
       ▼
terraform apply
       │
       ▼
AWS Infrastructure
       │
       ▼
terraform destroy
```

---

## Networking

I learned why public and private subnets are used for different purposes.

```text
Internet
   │
   ▼
Public EC2
   │
   ▼
Private RDS
```

The application needs to be reachable, but the database does not need to be exposed directly to the internet.

---

## Security Groups

I learned that Security Groups can reference other Security Groups.

Instead of allowing PostgreSQL from everywhere:

```text
0.0.0.0/0 : 5432
```

the database allows:

```text
EC2 Security Group : 5432
```

This significantly reduces unnecessary database exposure.

---

## IAM

I learned that an EC2 instance can receive AWS permissions using an IAM Role and Instance Profile.

This is better than placing permanent AWS access keys inside an application.

---

## Amazon S3

I learned how S3 can be used as object storage and how Block Public Access protects the bucket from accidental public exposure.

I also implemented S3 Versioning.

---

## Docker

I learned how Docker can package the GroceryMate application and its dependencies into a container that can run on EC2.

---

## Infrastructure as Code

The biggest overall lesson from the project was understanding that the full AWS environment can be described using code.

Instead of manually rebuilding everything, Terraform can recreate the infrastructure consistently.

---

# 🚀 Future Improvements

The current project provides the core AWS infrastructure required for GroceryMate.

Possible future improvements include:

- Amazon CloudWatch monitoring
- CloudWatch alarms
- Application logs
- Amazon SNS email notifications
- Application Load Balancer
- Auto Scaling
- HTTPS
- AWS Certificate Manager
- Route 53
- CI/CD pipeline
- Remote Terraform state
- S3 backend for Terraform state
- More restrictive IAM policies
- AWS Secrets Manager for database credentials
- Additional application subnets
- Improved monitoring and alerting

These services would improve scalability, monitoring, automation, security, and production readiness.

---

# 👤 Author

**Danny Chiou**

Cloud Engineering Student

### Technologies Practiced

- AWS
- Terraform
- Docker
- Amazon EC2
- Amazon RDS
- Amazon S3
- AWS IAM
- Amazon VPC
- Security Groups
- PostgreSQL
- Python
- Flask
- Git
- GitHub

---

# ✅ Project Summary

GroceryMate demonstrates a complete basic AWS cloud architecture managed using Terraform.

The project combines:

```text
Terraform
   │
   ▼
AWS Infrastructure
   │
   ├── VPC
   ├── Public Subnet
   ├── Private RDS Subnets
   ├── Internet Gateway
   ├── Route Table
   ├── EC2
   ├── Security Groups
   ├── RDS PostgreSQL
   ├── S3
   └── IAM
```

The final architecture demonstrates how compute, networking, storage, databases, permissions, security, containers, and Infrastructure as Code can work together as one cloud solution.
