output "instance_public_ip" { value = aws_instance.app.public_ip }
output "instance_id" { value = aws_instance.app.id }
output "ecr_repository_url" { value = aws_ecr_repository.app.repository_url }
