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


# vpc
resource "aws_vpc" "main" {
    
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    
    tags = merge(local.common_tags, {
        Name = "main"
    })
}

# internet gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = merge(local.common_tags, {
        Name = "main"
    })
}

# public subnet *2
resource "aws_subnet" "public" {
    count = 2
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.${count.index}.0/24"
    tags = merge(local.common_tags, {
        Name = "public-${count.index}"
    })
}

# private subnet *2
resource "aws_subnet" "private" {
    count = 2
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.${count.index + 10}.0/24"
    tags = merge(local.common_tags, {
        Name = "private-${count.index}"
    })
}

# public route table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    tags = merge(local.common_tags, {
        Name = "public"
    })
}

# private route table
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    tags = merge(local.common_tags, {
        Name = "private"
    })
}

# public route
resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
}



# public subnet association
resource "aws_route_table_association" "public" {
    count = 2
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

# private subnet association
resource "aws_route_table_association" "private" {
    count = 2
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}

# security group 定義
resource "aws_security_group" "main" {
  for_each = var.security_group_configs
  
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = each.value.name
  })
}

# インバウンドルール（別リソース）
resource "aws_security_group_rule" "ingress" {
  for_each = {
    for rule in flatten([
      for sg_key, sg_config in var.security_group_configs : [
        for idx, ingress_rule in sg_config.ingress : {
          key           = "${sg_key}-ingress-${idx}"
          sg_key        = sg_key
          type          = "ingress"
          from_port     = ingress_rule.from_port
          to_port       = ingress_rule.to_port
          protocol      = ingress_rule.protocol
          cidr_blocks   = ingress_rule.cidr_blocks
        }
      ]
    ]) : rule.key => rule
  }

  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.main[each.value.sg_key].id
}

# アウトバウンドルール（別リソース）
resource "aws_security_group_rule" "egress" {
  for_each = {
    for rule in flatten([
      for sg_key, sg_config in var.security_group_configs : [
        for idx, egress_rule in sg_config.egress : {
          key           = "${sg_key}-egress-${idx}"
          sg_key        = sg_key
          type          = "egress"
          from_port     = egress_rule.from_port
          to_port       = egress_rule.to_port
          protocol      = egress_rule.protocol
          cidr_blocks   = egress_rule.cidr_blocks
        }
      ]
    ]) : rule.key => rule
  }

  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.main[each.value.sg_key].id
}