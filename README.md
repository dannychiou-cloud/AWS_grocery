GroceryMate ☁️
A cloud-based GroceryMate application deployed using AWS, Terraform, Docker, and PostgreSQL.

<img width="1672" height="941" alt="project diagram" src="https://github.com/user-attachments/assets/58323404-abe8-490d-a199-601ee22c569a" />

This project was created as part of my Cloud Engineering learning path. The main focus is the AWS architecture, how the services work together, and how the infrastructure is managed with Terraform.

---

## 📌 Table of Contents

* [Project Overview](#-project-overview)
* [Architecture](#️-architecture)
* [AWS Services](#️-aws-services)
* [Terraform](#-terraform)
* [Docker](#-docker)
* [Cloud Interaction](#-cloud-interaction)
* [Environment Variables](#-environment-variables)
* [Security](#-security)
* [Monitoring](#-monitoring)
* [AWS Costs](#-aws-costs)
* [What I Learned](#-what-i-learned)
* [Future Improvements](#-future-improvements)

---

# 📖 Project Overview

**GroceryMate** is a Fullstack application running inside a Docker container on **Amazon EC2**.

The application uses:

* **Amazon RDS PostgreSQL** for application data
* **Amazon S3** for files such as avatar images
* **Terraform** to create the AWS infrastructure
* **CloudWatch** for monitoring

The main goal of the project is to understand how AWS networking, compute, databases, storage, security, and monitoring work together.

---

# 🏗️ Architecture

<img width="1672" height="941" alt="AWS Architecture Danny Chiou" src="https://github.com/user-attachments/assets/d2fe0782-26f9-4da6-a948-d66c1f5d8a07" />

The infrastructure runs inside a custom **Amazon VPC**.

The EC2 application server is located in a **public subnet**, while the RDS database uses **private subnets**.

<img width="672" height="567" alt="flowchart" src="https://github.com/user-attachments/assets/c42df9f8-126b-49e1-84dc-64322b274d71" />

 The Internet Gateway provides internet connectivity to the public side of the VPC.

RDS is not publicly accessible and communicates with the application internally.

---

# ☁️ AWS Services

| Service              | Purpose                              |
| -------------------- | ------------------------------------ |
| **EC2**              | Runs the GroceryMate application     |
| **RDS PostgreSQL**   | Stores application data              |
| **S3**               | Stores objects such as avatar images |
| **VPC**              | Provides the network environment     |
| **Internet Gateway** | Provides internet connectivity       |
| **Security Groups**  | Control network traffic              |
| **IAM**              | Gives EC2 permission to access S3    |
| **CloudWatch**       | Monitors the EC2 instance            |
| **SNS**              | Sends alarm notifications            |

---

# 🧱 Terraform

Terraform is used to create and manage the AWS infrastructure as code.

The main files are:

| File               | Purpose                     |
| ------------------ | --------------------------- |
| `main.tf`          | AWS infrastructure          |
| `variables.tf`     | Defines variables           |
| `terraform.tfvars` | Provides variable values    |
| `outputs.tf`       | Displays useful information |

### Main Commands

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

After testing, the infrastructure can be removed with:

```bash
terraform destroy
```

This makes the environment repeatable and also helps avoid unnecessary AWS costs.

---

# 🐳 Docker

The GroceryMate application is packaged using Docker.

The `Dockerfile` defines the application image.

Build the image:

```bash
docker build -t grocerymate .
```

Run the container:

```bash
docker run -d --env-file .env -p 80:5000 grocerymate
```

Docker allows the application and its dependencies to run consistently on EC2.

---

# 🔄 Cloud Interaction

The main cloud communication is simple:

### User → EC2

Users access GroceryMate through the EC2 instance in the public subnet.

### EC2 → RDS

The application connects to PostgreSQL using:

```text
TCP 5432
```

RDS is configured with:

```hcl
publicly_accessible = false
```

Only the EC2 Security Group is allowed to connect to the database on port 5432.

### EC2 → S3

The application uses Amazon S3 to store and retrieve objects.

EC2 receives the required permissions through an **IAM Role**, so AWS access keys do not need to be stored inside the application.

---

# 🔐 Environment Variables

Application configuration such as database details is handled using environment variables.

Example `.env` file:

```text
DB_HOST=<RDS endpoint>
DB_NAME=<database name>
DB_USER=<database user>
DB_PASSWORD=<database password>
```

The `.env` file is excluded from GitHub using `.gitignore` because it can contain sensitive information.

AWS access to S3 is handled separately through the EC2 IAM Role.

---

# 🔒 Security

The project includes several basic security measures:

| Measure          | Implementation                 |
| ---------------- | ------------------------------ |
| Database         | RDS runs in private subnets    |
| Public access    | RDS is not publicly accessible |
| Database traffic | Port 5432 only from EC2        |
| SSH              | Restricted using `ssh_cidr`    |
| S3               | Block Public Access enabled    |
| S3 files         | Versioning enabled             |
| AWS permissions  | EC2 uses an IAM Role           |
| Secrets          | `.env` excluded from Git       |

The main idea is to keep the **application reachable** while keeping the **database private**.

---

# 📈 Monitoring

**Amazon CloudWatch** is used to monitor the EC2 instance.

A CloudWatch alarm monitors the configured EC2 metric.

When the alarm condition is reached, **Amazon SNS** can send an email notification.

<img width="382" height="491" alt="cloudwatch flow" src="https://github.com/user-attachments/assets/57176762-ec74-4f7c-926d-4cd55ba9ea4f" />


This provides basic monitoring and notification for the infrastructure.

---

# 💰 AWS Costs

The main AWS costs in this project are:

| Service           | Main Cost                         |
| ----------------- | --------------------------------- |
| **EC2**           | Instance running time             |
| **RDS**           | Database running time and storage |
| **S3**            | Storage and requests              |
| **CloudWatch**    | Monitoring usage                  |
| **Data Transfer** | Data transferred                  |

For this learning environment, **EC2 and RDS** are the main resources to watch.

After testing, unused infrastructure can be removed using:

```bash
terraform destroy
```

This helps prevent unnecessary costs.

---

# 🎓 What I Learned

This project helped me understand how different cloud components work together.

I learned how to:

* Build AWS infrastructure using Terraform
* Use public and private subnets
* Run a Dockerized application on EC2
* Connect EC2 securely to RDS
* Store objects in Amazon S3
* Use IAM Roles instead of hardcoded AWS credentials
* Protect resources using Security Groups
* Use environment variables for application configuration
* Monitor infrastructure using CloudWatch
* Use SNS for alarm notifications
* Consider AWS costs when designing infrastructure

The biggest lesson was understanding how these services interact as **one cloud architecture**.

---

# 🚀 Future Improvements

Possible improvements include:

* CloudWatch application logs
* HTTPS
* Application Load Balancer
* Auto Scaling
* Route 53
* CI/CD pipeline
* AWS Secrets Manager
* Remote Terraform state
* More restrictive IAM permissions

These improvements would make the application more secure, scalable, and production-ready.

---

# 👤 Author

**Danny Chiou**
Cloud Engineering Student

**Technologies:** AWS • Terraform • Docker • EC2 • RDS • S3 • IAM • VPC • CloudWatch • SNS • PostgreSQL • Python • Flask • Git • GitHub

---

# ✅ Summary

GroceryMate demonstrates a basic AWS cloud architecture managed using Terraform.

```text
Internet
   │
   ▼
Internet Gateway
   │
   ▼
EC2 + Docker
   │
   ├────► Private RDS
   │
   └────► Amazon S3

EC2 ──► CloudWatch ──► SNS
```

**Terraform** manages the infrastructure, **Docker** runs the application, **RDS** stores application data, **S3** stores objects, **IAM** controls permissions, and **CloudWatch** provides monitoring.

The project demonstrates how the main components of a cloud application can work together securely on AWS.
