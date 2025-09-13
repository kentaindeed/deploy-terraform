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