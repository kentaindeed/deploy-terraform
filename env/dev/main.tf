# dev environment

locals {
    common_variables = {
        region = "ap-southeast-1"
        profile = "default"
    }
}

locals {
    common_tags = {
        Environment = "dev"
        Project = "terraform-project"
        Owner = "kentaindeed"
        CreatedBy = "terraform"
        CreatedAt = "2025-01-01"
    }
}

# network
module "network" {
    source = "../../modules/network"
    # デフォルト値を使用（必要に応じて上書き可能）
}

# ec2
module "ec2" {
    source = "../../modules/ec2"
    
    ami           = var.ami
    instance_type = var.instance_type
    subnet_ids    = module.network.public_subnet_ids
    instance_count = var.instance_count
    security_group_ids = module.network.web_security_group_ids  # 追加

}


