# 🚀 AWS DevOps Final Project

This project demonstrates a complete automated DevOps workflow for provisioning cloud infrastructure and deploying containerized applications.

## 🏗️ Architecture Overview
* **Infrastructure as Code (IaC):** Terraform
* **Cloud Provider:** AWS (VPC, EKS, NLB, API Gateway)
* **Orchestration:** Kubernetes (EKS)
* **CI/CD:** GitHub Actions

## 📂 Project Structure
```text
.
├── vpc/                # Core Infrastructure (VPC, EKS, Networking)
│   ├── vpc.tf          # Network configuration
│   ├── eks.tf          # EKS Cluster definition
│   ├── provider.tf     # AWS Provider & Backend settings
│   └── variables.tf    # Resource variables
├── output.tf           # Global outputs
├── .github/workflows/  # CI/CD Pipeline definitions
└── README.md           # Documentation

