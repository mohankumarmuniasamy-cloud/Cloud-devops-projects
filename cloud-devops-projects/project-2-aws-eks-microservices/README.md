# Project 2 — AWS Kubernetes & Microservices Deployment

## Architecture

GitHub → Jenkins → Docker → ECR → Amazon EKS → Kubernetes Service/ALB → Application → Prometheus/Grafana

## 1. Create EKS

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform validate
terraform plan
terraform apply
aws eks update-kubeconfig --region ap-south-1 --name devops-eks-cluster
kubectl get nodes
```

The EKS Terraform configuration uses the public Terraform AWS VPC and EKS modules. Pin versions are included for repeatability.

## 2. Build and push image manually

From the project root:

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGISTRY=${ACCOUNT_ID}.dkr.ecr.ap-south-1.amazonaws.com
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin $REGISTRY
docker build -t eks-microservices-demo -f docker/Dockerfile .
docker tag eks-microservices-demo:latest $REGISTRY/eks-microservices-demo:latest
docker push $REGISTRY/eks-microservices-demo:latest
```

Update `kubernetes/deployment.yaml` with your account ID if deploying manually.

## 3. Deploy Kubernetes

```bash
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/configmap.yaml
kubectl apply -f kubernetes/secret.yaml
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
kubectl get pods -n devops-demo
kubectl get svc -n devops-demo
```

For production, do not commit real secret values. Prefer AWS Secrets Manager/External Secrets or another managed secret workflow.

## 4. Prometheus and Grafana

Install the community kube-prometheus-stack with Helm:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring
kubectl get pods -n monitoring
```

Access Grafana locally:

```bash
kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring
```

Then open `http://localhost:3000`.

Get the generated admin password:

```bash
kubectl get secret monitoring-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode; echo
```

## 5. Jenkins

Create a Jenkins Pipeline job using `jenkins/Jenkinsfile`. The Jenkins agent needs Docker, AWS CLI, kubectl and permissions for ECR and EKS.

## Cleanup

```bash
cd terraform
terraform destroy
```
