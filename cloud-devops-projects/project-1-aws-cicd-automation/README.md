# Project 1 — AWS Cloud Infrastructure & CI/CD Automation

## Architecture

GitHub → Jenkins → Docker Build/Test → Amazon ECR → EC2/ASG → ALB → Application → CloudWatch

## 1. Create infrastructure

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit ami_id with a valid Amazon Linux 2023 AMI ID.
terraform init
terraform validate
terraform plan
terraform apply
```

## 2. Build locally

From the project root:

```bash
docker build -t aws-cicd-demo -f docker/Dockerfile .
docker run --rm -p 8080:80 aws-cicd-demo
```

Open `http://localhost:8080`.

## 3. Jenkins

Create a Pipeline job pointing to this repository and `jenkins/Jenkinsfile`. The Jenkins agent needs Docker and AWS CLI plus an IAM role/user permission to access ECR.

## 4. Ansible

Replace the inventory placeholders and use a secured SSH key outside Git:

```bash
ansible-playbook -i ansible/inventory ansible/deploy.yml
```

## Production notes

The Terraform ALB listener is intentionally a safe placeholder. Register the application target through your deployment strategy or CodeDeploy before using it as a production release path.
