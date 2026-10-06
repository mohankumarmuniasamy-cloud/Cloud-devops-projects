# Project 2 — AWS Kubernetes & Microservices Deployment

## Objective

Deploy a containerized application to Amazon EKS using Docker, Amazon ECR, Kubernetes, Jenkins, Terraform, Prometheus and Grafana.

## Architecture

```text
Developer → GitHub → Jenkins
                     ├→ Test
                     ├→ Docker Build → ECR
                     └→ kubectl → Amazon EKS
                                      |
                              Deployment / Service
                                      |
                                  Application
                                      |
                              Prometheus → Grafana
```

## Prerequisites

- AWS account
- AWS CLI
- Docker
- Git
- Terraform
- kubectl
- eksctl
- Helm
- Jenkins
- IAM permissions for EKS/ECR/VPC

Verify:

```bash
aws --version
docker --version
kubectl version --client
eksctl version
helm version
terraform version
```

Configure:

```bash
aws configure
aws sts get-caller-identity
```

Variables:

```bash
export AWS_REGION=ap-south-1
export EKS_CLUSTER=aws-devops-project2
export ECR_REPO=aws-devops-project2
```

## 1. Create ECR

```bash
aws ecr create-repository   --repository-name $ECR_REPO   --region $AWS_REGION
```

Login:

```bash
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
```

## 2. Build and Push

```bash
cd docker
docker build -t $ECR_REPO:latest .

docker tag $ECR_REPO:latest YOUR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest

docker push YOUR_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
```

Update `kubernetes/deployment.yaml` with your ECR image.

## 3. Create EKS

For a lab:

```bash
eksctl create cluster   --name $EKS_CLUSTER   --region $AWS_REGION   --nodes 2   --node-type t3.medium   --managed
```

Verify:

```bash
kubectl get nodes
```

> EKS can incur substantial charges. Delete the cluster after practice.

## 4. Deploy Kubernetes Resources

```bash
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/configmap.yaml
kubectl apply -f kubernetes/secret.yaml
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
```

Verify:

```bash
kubectl get all -n aws-devops
kubectl get pods -n aws-devops -o wide
```

## 5. Test the Service

```bash
kubectl get svc -n aws-devops
```

For local testing:

```bash
kubectl port-forward svc/project2-service 8080:80 -n aws-devops
```

Open `http://localhost:8080`.

## 6. Ingress

If AWS Load Balancer Controller is installed and configured:

```bash
kubectl apply -f kubernetes/ingress.yaml
kubectl get ingress -n aws-devops
```

## 7. Jenkins

Configure a Jenkins Pipeline connected to GitHub.

Recommended stages:

```text
Checkout
→ Test
→ Docker Build
→ ECR Login
→ Push Image
→ kubectl Apply
→ Rollout Status
```

The Jenkins agent needs access to `docker`, `aws` and `kubectl`.

## 8. Prometheus and Grafana

Add the Helm repository:

```bash
helm repo add prometheus-community   https://prometheus-community.github.io/helm-charts

helm repo update
```

Install:

```bash
helm install monitoring prometheus-community/kube-prometheus-stack   --namespace monitoring   --create-namespace
```

Verify:

```bash
kubectl get pods -n monitoring
```

Access Grafana locally:

```bash
kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring
```

Open `http://localhost:3000`.

Get the admin password:

```bash
kubectl get secret monitoring-grafana   -n monitoring   -o jsonpath="{.data.admin-password}" | base64 --decode
```

Useful checks:

```bash
kubectl top pods -n aws-devops
kubectl top nodes
```

## Troubleshooting

```bash
kubectl describe pod POD_NAME -n aws-devops
kubectl logs POD_NAME -n aws-devops
kubectl describe deployment project2-deployment -n aws-devops
kubectl rollout status deployment/project2-deployment -n aws-devops
```

## Cleanup

Application:

```bash
kubectl delete namespace aws-devops
```

Monitoring:

```bash
helm uninstall monitoring -n monitoring
kubectl delete namespace monitoring
```

EKS:

```bash
eksctl delete cluster   --name $EKS_CLUSTER   --region $AWS_REGION
```

ECR:

```bash
aws ecr delete-repository   --repository-name $ECR_REPO   --region $AWS_REGION   --force
```

## Expected Outcome

You demonstrate Docker, ECR, EKS, Kubernetes, Jenkins, ConfigMaps, Secrets, Services, Ingress, Prometheus, Grafana and Kubernetes troubleshooting.
