# SonarQube Infrastructure on AWS using Terraform

This project provisions a **secure, production-style AWS infrastructure** to deploy **SonarQube** on a private EC2 instance using **Terraform**.  
Access is controlled via a **Bastion Host**, traffic is managed by an **Application Load Balancer (ALB)**, and permissions are handled through **IAM**.

---

## 🏗️ Architecture Overview

### High-Level Design
- Custom **VPC** with public and private subnets
- **Internet Gateway** for public access
- **NAT Gateway** for outbound internet access from private subnets
- **Bastion Host** for secure SSH access
- **Private EC2 instance** running SonarQube (Docker)
- **Application Load Balancer (ALB)** for web access
- **IAM roles and policies** for secure access
- Fully automated using **Terraform**

---

## 📌 Components Breakdown

### 1️⃣ VPC & Networking
- Custom VPC with DNS support enabled
- Multiple **public subnets**
- Multiple **private subnets**
- Route tables:
  - Public subnet → Internet Gateway
  - Private subnet → NAT Gateway

---

### 2️⃣ Bastion Host
- Deployed in a **public subnet**
- Has a public IP
- SSH access restricted to **your IP only**
- Used to access private EC2 instances securely

🔐 **Why Bastion?**
- No public IP on private servers
- Reduced attack surface
- Industry best practice

---

### 3️⃣ SonarQube EC2 Instance
- Deployed in a **private subnet**
- No public IP
- Docker-based SonarQube deployment
- Internet access via NAT Gateway
- Accessed through:
  - Bastion Host (SSH)
  - Application Load Balancer (HTTP)

---

### 4️⃣ Application Load Balancer (ALB)
- Deployed in public subnets
- Routes traffic to private SonarQube EC2
- Listener:
  - HTTP : 80 → SonarQube (port 9000)
- Enables future scalability & HTTPS support

---

### 5️⃣ IAM Configuration
IAM is used to follow the **principle of least privilege**.

#### IAM Roles:
- EC2 Role:
  - Allows access to:
    - CloudWatch Logs
    - SSM (optional)
- Terraform IAM permissions:
  - VPC, EC2, ALB, IAM, Security Groups

---

### 6️⃣ Security Groups
| Component        | Allowed Inbound | Source |
|------------------|----------------|--------|
| Bastion SG       | SSH (22)       | Your IP |
| SonarQube SG     | SSH (22)       | Bastion SG |
| SonarQube SG     | TCP (9000)     | ALB SG |
| ALB SG           | HTTP (80)      | 0.0.0.0/0 |

---

## 🚀 Provisioning Flow

1. Terraform creates networking (VPC, subnets, routes)
2. Bastion Host is launched in public subnet
3. NAT Gateway is attached
4. SonarQube EC2 launches in private subnet
5. Docker & SonarQube are installed automatically
6. ALB routes traffic to SonarQube

---

## 🧰 Tools & Technologies Used
- **Terraform**
- **AWS EC2**
- **AWS VPC**
- **AWS ALB**
- **AWS IAM**
- **Docker**
- **SonarQube**
- **GitHub Actions (CI/CD)**

---

## 📂 Project Structure

```bash
.
├── vpc.tf
├── ec2.tf
├── alb.tf
├── security_groups.tf
├── iam.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── README.md
└── .gitignore
