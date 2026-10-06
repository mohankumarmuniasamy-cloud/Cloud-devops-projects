output "vpc_id" { value = aws_vpc.main.id }
output "ecr_repository_url" { value = aws_ecr_repository.app.repository_url }
output "load_balancer_dns" { value = aws_lb.web.dns_name }
output "autoscaling_group" { value = aws_autoscaling_group.web.name }
