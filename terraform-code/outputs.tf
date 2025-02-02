# Output the public IP of the Elastic IP (EIP) associated with the EC2 instance
output "eip" {
  value       = aws_eip.static_eip.public_ip                                        # Fetching the public IP address of the Elastic IP
  description = "The public IP of the Elastic IP associated with the EC2 instance." # Optional description to explain the output
}

# Output the name of the ECR repository created
output "ecr" {
  value       = aws_ecr_repository.ecr_repo.name                                 # Fetching the name of the ECR repository
  description = "The name of the ECR repository where Docker images are stored." # Optional description to explain the output
}
