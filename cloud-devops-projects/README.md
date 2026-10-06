# AWS DevOps Projects Portfolio

A practical AWS DevOps portfolio containing three end-to-end projects covering cloud infrastructure, CI/CD, containers, Kubernetes, infrastructure as code, monitoring, automation, and DevSecOps.

## Projects

| Project | Focus | Core Technologies |
|---|---|---|
| [Project 1](./project-1-aws-cicd-automation/) | AWS Cloud Infrastructure & CI/CD Automation | EC2, VPC, ALB, ASG, ECR, Docker, Jenkins, Terraform, Ansible, CloudWatch |
| [Project 2](./project-2-aws-eks-microservices/) | AWS Kubernetes & Microservices Deployment | EKS, Kubernetes, ECR, Docker, Jenkins, Terraform, Prometheus, Grafana |
| [Project 3](./project-3-aws-devsecops/) | AWS DevSecOps & Infrastructure Automation | Jenkins, Terraform, Ansible, Docker, ECR, SonarQube, IAM, Prometheus |

## Portfolio Architecture

```text
Developer → GitHub → Jenkins
                      ├── Docker → Amazon ECR → EC2 / EKS
                      └── Terraform → AWS Infrastructure
                                              |
                              +---------------+---------------+
                              |                               |
                         Project 1                         Project 2
                           EC2/ALB                              EKS
                              |                                 |
                         CloudWatch                     Prometheus/Grafana

Project 3 adds SonarQube, security scanning and Ansible automation.
```

## Common Prerequisites

- AWS account
- AWS CLI
- Git
- Docker
- Terraform
- Jenkins
- Ansible
- kubectl for Project 2
- eksctl for the easiest EKS workflow
- Helm for Project 2 monitoring
- SSH client
- GitHub repository

Verify:

```bash
aws --version
git --version
docker --version
terraform version
ansible --version
kubectl version --client
eksctl version
helm version
```

Configure AWS:

```bash
aws configure
aws sts get-caller-identity
```

## Recommended Learning Order

1. **Project 1** — EC2-based CI/CD and AWS infrastructure.
2. **Project 2** — Docker/ECR and Kubernetes on EKS.
3. **Project 3** — DevSecOps, quality gates, security scanning and automation.

## Important Configuration

Replace example values such as:

```text
YOUR_AWS_REGION
YOUR_ACCOUNT_ID
YOUR_ECR_REPOSITORY
YOUR_EKS_CLUSTER
YOUR_KEY_NAME
YOUR_EC2_PUBLIC_IP
```

Do not commit:

- AWS access keys
- `.pem` / `.ppk` files
- `.env` files
- Terraform state
- real Kubernetes secrets
- passwords
- API tokens
- Jenkins secrets

## Project Setup Guides

### Project 1
[Open Project 1 Setup Guide](./project-1-aws-cicd-automation/SETUP.md)

```text
GitHub → Jenkins → Docker → ECR → EC2 → ALB → Application
                         Terraform / Ansible
                              CloudWatch
```

### Project 2
[Open Project 2 Setup Guide](./project-2-aws-eks-microservices/SETUP.md)

```text
GitHub → Jenkins → Docker → ECR → EKS → Kubernetes
                                      |
                                Prometheus → Grafana
```

### Project 3
[Open Project 3 Setup Guide](./project-3-aws-devsecops/SETUP.md)

```text
GitHub → Jenkins → SonarQube → Security Scan
                         ↓
                    Docker → ECR
                         ↓
                 Terraform / Ansible
                         ↓
                       EC2
                         ↓
                    Monitoring
```

## Cleanup

Always remove lab resources after practice.

Terraform:

```bash
terraform destroy
```

EKS:

```bash
eksctl delete cluster --name YOUR_EKS_CLUSTER --region YOUR_AWS_REGION
```

Local Docker:

```bash
docker system prune
```

## Portfolio Note

This repository is designed as a hands-on learning and portfolio project. AWS AMI IDs, networking values, instance sizes, security rules, and resource names must be adapted to the target AWS region and account.
