variable "aws_region" { type = string default = "ap-south-1" }
variable "project_name" { type = string default = "aws-devsecops-demo" }
variable "vpc_cidr" { type = string default = "10.30.0.0/16" }
variable "ami_id" { type = string description = "Amazon Linux 2023 AMI ID" }
variable "instance_type" { type = string default = "t3.micro" }
