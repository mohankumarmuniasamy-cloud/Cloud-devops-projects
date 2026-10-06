# Project 3 — AWS DevSecOps & Infrastructure Automation

## Objective

Build a DevSecOps pipeline that performs source checkout, code-quality analysis, security scanning, Docker image creation, ECR publishing, infrastructure automation and monitoring.

## Architecture

```text
Developer → GitHub → Jenkins
                     ├→ SonarQube
                     ├→ Security Scan
                     ├→ Docker Build → ECR
                     ├→ Terraform
                     └→ Ansible → EC2
                                      |
                                  Application
                                      |
                                Monitoring
```

## Prerequisites

- AWS account and IAM permissions
- AWS CLI
- Git
- Docker
- Jenkins
- Terraform
- Ansible
- Java where required by Jenkins/SonarQube
- SonarQube
- EC2 key pair
- GitHub repository

Verify:

```bash
aws --version
docker --version
terraform version
ansible --version
java -version
```

## 1. Configure AWS

```bash
aws configure
aws sts get-caller-identity
```

```bash
export AWS_REGION=ap-south-1
export ECR_REPO=aws-devops-project3
```

## 2. Create ECR

```bash
aws ecr create-repository   --repository-name $ECR_REPO   --region $AWS_REGION
```

Login:

```bash
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
```

## 3. Run SonarQube for a Lab

```bash
docker volume create sonarqube_data
docker volume create sonarqube_logs
docker volume create sonarqube_extensions

docker run -d   --name sonarqube   -p 9000:9000   -v sonarqube_data:/opt/sonarqube/data   -v sonarqube_logs:/opt/sonarqube/logs   -v sonarqube_extensions:/opt/sonarqube/extensions   sonarqube:lts-community
```

Open:

```text
http://localhost:9000
```

For production, use the supported SonarQube architecture and external database configuration rather than a single lab container.

## 4. Configure SonarQube

Update:

```text
security/sonar-project.properties
```

Example:

```properties
sonar.projectKey=aws-devops-project3
sonar.projectName=AWS DevOps Project 3
sonar.sources=application
```

Create a SonarQube token and store it in Jenkins Credentials. Do not commit the token.

## 5. Run Security Scan

```bash
chmod +x security/security-scan.sh
./security/security-scan.sh
```

For enterprise DevSecOps, extend this with dedicated SAST, dependency, container and IaC scanners.

## 6. Build and Test Docker

```bash
cd docker
docker build -t $ECR_REPO:latest .

docker run -d   --name project3-app   -p 8080:80   $ECR_REPO:latest

curl http://localhost:8080
docker rm -f project3-app
```

## 7. Push to ECR

```bash
docker tag $ECR_REPO:latest YOUR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest

docker push YOUR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
```

## 8. Terraform

```bash
cd ../terraform
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Review all variables and AWS resource settings before applying.

## 9. Ansible

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

For Amazon Linux use `ec2-user`.

## 10. Jenkins DevSecOps Pipeline

Recommended stages:

```text
Checkout
→ Unit / Basic Tests
→ SonarQube Analysis
→ Security Scan
→ Docker Build
→ Container Scan
→ ECR Push
→ Terraform Plan
→ Terraform Apply
→ Ansible Deployment
→ Health Check
```

Use Jenkins Credentials for AWS, GitHub and SonarQube. Never place credentials directly in pipeline source code.

## 11. Monitoring

Use:

```text
monitoring/prometheus.yml
```

and AWS CloudWatch.

Useful EC2 metrics:

```text
CPUUtilization
NetworkIn
NetworkOut
DiskReadOps
DiskWriteOps
StatusCheckFailed
```

## Verification

ECR:

```bash
aws ecr describe-images   --repository-name $ECR_REPO   --region $AWS_REGION
```

EC2:

```bash
aws ec2 describe-instances --region $AWS_REGION
```

Ansible:

```bash
ansible all -i ansible/inventory -m ping
```

## Cleanup

Stop SonarQube:

```bash
docker rm -f sonarqube
```

Remove its lab volumes if no longer needed:

```bash
docker volume rm sonarqube_data sonarqube_logs sonarqube_extensions
```

Destroy Terraform infrastructure:

```bash
cd terraform
terraform destroy
```

Delete ECR:

```bash
aws ecr delete-repository   --repository-name $ECR_REPO   --region $AWS_REGION   --force
```

Local Docker cleanup:

```bash
docker system prune
```

## Expected Outcome

You demonstrate Jenkins, SonarQube, DevSecOps, Docker, ECR, Terraform, Ansible, EC2, IAM, Prometheus, CloudWatch and automated deployment.
