# AWS Services Used

- EC2: application compute
- ECR: Docker image registry
- ALB: HTTP load balancing
- Auto Scaling Group: instance scaling
- VPC/Subnets/Route Tables/Internet Gateway: networking
- IAM: permissions
- CloudWatch: monitoring
- S3/CodeDeploy: optional production artifact/deployment extensions

## ECR commands

```bash
aws ecr create-repository --repository-name aws-cicd-demo --region ap-south-1
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com
docker build -t aws-cicd-demo -f docker/Dockerfile .
docker tag aws-cicd-demo:latest ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/aws-cicd-demo:latest
docker push ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/aws-cicd-demo:latest
```
