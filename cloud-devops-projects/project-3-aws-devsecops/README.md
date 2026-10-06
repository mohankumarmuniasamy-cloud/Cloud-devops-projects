# Project 3 — AWS DevSecOps & Infrastructure Automation

## Architecture

GitHub → Jenkins → Code Quality → Security Scan → Docker Build/Test → ECR → Terraform/Ansible → EC2 → Monitoring

## 1. Infrastructure

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Set a valid Amazon Linux 2023 AMI ID.
terraform init
terraform validate
terraform plan
terraform apply
```

The EC2 role includes SSM access and ECR read-only access. Prefer SSM Session Manager instead of exposing SSH in production.

## 2. Security scan

```bash
cd ..
./security/security-scan.sh
```

The script is intentionally a lightweight portfolio example. For production, integrate dedicated SAST, dependency, secret and container scanners.

## 3. SonarQube

Configure a Jenkins SonarQube server and scanner, then use the supplied `security/sonar-project.properties`. A common local lab is:

```bash
docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community
```

Configure the Jenkins SonarQube plugin/credentials before adding the scanner command to the pipeline.

## 4. Docker/ECR

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGISTRY=${ACCOUNT_ID}.dkr.ecr.ap-south-1.amazonaws.com
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin $REGISTRY
docker build -t aws-devsecops-demo -f docker/Dockerfile .
docker tag aws-devsecops-demo:latest $REGISTRY/aws-devsecops-demo:latest
docker push $REGISTRY/aws-devsecops-demo:latest
```

## 5. Ansible

Replace inventory placeholders and use a private key stored outside Git:

```bash
ansible-playbook -i ansible/inventory ansible/deploy.yml
```

## Monitoring

Use CloudWatch for AWS infrastructure and application logs. Prometheus/Grafana can be added to a Kubernetes environment or a dedicated monitoring host. The `monitoring/prometheus.yml` file is a minimal configuration example.
