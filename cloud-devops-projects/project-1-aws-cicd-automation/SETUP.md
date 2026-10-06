# Project 1 — AWS Cloud Infrastructure & CI/CD Automation

## Objective

Build an AWS-based CI/CD environment for a containerized web application using Jenkins, Docker, Amazon ECR, EC2, Terraform, Ansible, ALB, Auto Scaling and CloudWatch.

## Architecture

```text
Developer → GitHub → Jenkins
                     ├→ Test
                     ├→ Docker Build → Amazon ECR
                     └→ Deployment → EC2
                                      ↓
                                     ALB
                                      ↓
                                  Application

Terraform → VPC / EC2 / ALB / ASG
Ansible   → EC2 configuration
CloudWatch → monitoring
```

## Prerequisites

- AWS account and IAM permissions
- AWS CLI
- Git
- Docker
- Terraform
- Ansible
- Jenkins
- EC2 key pair
- GitHub repository

Verify:

```bash
aws --version
terraform version
ansible --version
docker --version
```

## 1. Configure AWS

```bash
aws configure
aws sts get-caller-identity
```

Set the region:

```bash
export AWS_REGION=ap-south-1
```

PowerShell:

```powershell
$env:AWS_REGION="ap-south-1"
```

## 2. Test the Application

```bash
cd application
python3 -m http.server 8080
```

Open `http://localhost:8080`, then press `Ctrl+C`.

## 3. Build the Docker Image

```bash
cd ../docker
docker build -t aws-devops-project1:latest .
docker run -d --name project1-app -p 8080:80 aws-devops-project1:latest
curl http://localhost:8080
docker rm -f project1-app
```

## 4. Push to Amazon ECR

```bash
aws ecr create-repository   --repository-name aws-devops-project1   --region $AWS_REGION
```

Login:

```bash
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
```

Tag and push:

```bash
docker tag aws-devops-project1:latest YOUR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/aws-devops-project1:latest

docker push YOUR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/aws-devops-project1:latest
```

## 5. Provision AWS Infrastructure

```bash
cd ../terraform
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Review the Terraform files first and adapt AMI IDs, key-pair names, networking and security rules to your region.

## 6. Configure EC2 with Ansible

Update `ansible/inventory`:

```ini
[web]
YOUR_EC2_PUBLIC_IP ansible_user=ubuntu
```

Test:

```bash
ansible all -i inventory -m ping
```

Deploy:

```bash
ansible-playbook -i inventory deploy.yml
```

For Amazon Linux use `ec2-user` instead of `ubuntu`.

## 7. Jenkins Pipeline

Create a Jenkins Pipeline connected to GitHub and point it to:

```text
jenkins/Jenkinsfile
```

Recommended stages:

```text
Checkout → Test → Docker Build → ECR Login → Push → Deploy
```

Store AWS/GitHub credentials in Jenkins Credentials. Never hard-code secrets in the Jenkinsfile.

## 8. Verify

Get the load balancer:

```bash
aws elbv2 describe-load-balancers --region $AWS_REGION
```

Open the ALB DNS name in a browser.

CloudWatch metrics to check:

- CPUUtilization
- NetworkIn
- NetworkOut
- StatusCheckFailed

## Cleanup

```bash
cd terraform
terraform destroy
```

Then:

```bash
aws ecr delete-repository   --repository-name aws-devops-project1   --region $AWS_REGION   --force
```

Local Docker cleanup:

```bash
docker system prune
```

## Expected Outcome

You demonstrate EC2, VPC, ALB, Auto Scaling, Docker, ECR, Jenkins, Terraform, Ansible and CloudWatch in one CI/CD workflow.
