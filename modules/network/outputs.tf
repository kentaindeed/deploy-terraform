output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}


output "security_group_ids" {
  description = "Security group IDs"
  value = {
    for k, v in aws_security_group.main : k => v.id
  }
}

# Web用（HTTP + HTTPS + SSH）のセキュリティグループIDリスト
output "web_security_group_ids" {
  description = "Web server security group IDs (HTTP, HTTPS, SSH)"
  value = [
    aws_security_group.main["dev_security"].id
  ]
}