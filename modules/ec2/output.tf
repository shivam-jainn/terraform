output "frontend_public_ip" {
  value       = aws_instance.frontend.public_ip
  description = "Public IP of the frontend Instance"
}

output "backend_private_ip" {
  value       = aws_instance.backend.private_ip
  description = "Private IP of the backend Instance"
}
