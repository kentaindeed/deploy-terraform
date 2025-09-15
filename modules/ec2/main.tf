# ec2
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
}


resource "aws_instance" "ec2" {
    count         = var.instance_count
    ami           = var.ami
    instance_type = var.instance_type
    subnet_id     = var.subnet_ids[count.index % length(var.subnet_ids)]
    vpc_security_group_ids = var.security_group_ids
    tags = merge(local.common_tags, {
        Name = "${local.common_tags.Project}-ec2-${count.index + 1}"
    })
}

