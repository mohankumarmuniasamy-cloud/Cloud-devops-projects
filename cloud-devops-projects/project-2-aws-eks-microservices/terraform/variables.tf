variable "aws_region" { type = string default = "ap-south-1" }
variable "cluster_name" { type = string default = "devops-eks-cluster" }
variable "kubernetes_version" { type = string default = "1.33" }
variable "vpc_cidr" { type = string default = "10.20.0.0/16" }
variable "node_instance_type" { type = string default = "t3.medium" }
