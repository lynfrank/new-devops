# 🚀 DevOps CI/CD Pipeline: Jenkins on Azure with Terraform

Hello! I'm **Paul Stanil Grasian** **https://www.linkedin.com/in/paul-stanil-grasian-9a9989187/**, a Cloud/DevOps Engineer certified in Azure (AZ-104). I'm currently seeking new opportunities in cloud infrastructure and DevOps. This project demonstrates a complete CI/CD pipeline implementation using tools I specialize in.

## 🌟 Project Overview
This project implements an automated CI/CD pipeline for a containerized application:
- **Infrastructure**: Azure spot VM provisioned with Terraform
- **CI/CD**: Jenkins pipeline triggered by GitHub webhooks
- **Containerization**: Docker for application deployment
- **Application**: Sample voting app from [docker/getting-started-app](https://github.com/docker/getting-started-app)
- **Database**: MySQL with persistent storage

## ⚙️ Technical Stack
- **Cloud**: Microsoft Azure
- **Infrastructure as Code**: Terraform
- **CI/CD**: Jenkins, GitHub Webhooks
- **Containerization**: Docker
- **Scripting**: Bash, YAML
- **Database**: MySQL
- **Web Server**: Apache

## 📦 Key Components

### Infrastructure Flow
```mermaid
graph LR
A[Developer Machine] -->|Code Commit| B[GitHub]
B -->|Webhook Trigger| C[Jenkins on Azure VM]
C --> D[Pipeline Execution]
D --> E1[Checkout Code]
D --> E2[Build Application]
D --> E3[Run Tests]
D --> E4[Build Docker Images]
D --> E5[Deploy Containers]
E5 --> F[Frontend Container]
E5 --> G[Backend Container]
E5 --> H[MySQL Container]
H -->|Persistent Storage| I[Azure Disk]
classDef dev fill:#9f9,stroke:#333;
class A dev;
