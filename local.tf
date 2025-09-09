# common variables and security group are defined


locals {
  common_variables = {
    region = "ap-southeast-1"
    profile = "default"
  }

  common_tags = {
    Environment = "dev"
    Project = "terraform-project"
    Owner = "kentaindeed"
    CreatedBy = "terraform"
    CreatedAt = "2025-01-01"
  }

    # HTTP 80 security group 0.0.0.0/0
    # HTTP 443 security group 0.0.0.0/0
    http_80_security_group = {
        name = "http-80-security-group"
        description = "HTTP 80 security group"
        ingress = [
            {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
            }
        ]
        egress = [
            {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
            }
        ]
    }

    http_443_security_group = {
        name = "http-443-security-group"
        description = "HTTP 443 security group"
        ingress = [
            {
                from_port = 443
                to_port = 443
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
            }
        ]
        egress = [
            {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
            }
        ]
    }
}