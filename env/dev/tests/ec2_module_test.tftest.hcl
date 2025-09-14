# テスト用の変数定義

provider "aws" {
  region                      = "ap-southeast-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

variables {
  ami            = "ami-047126e50991d067b"
  instance_type  = "t2.micro"
  subnet_ids     = ["subnet-12345678", "subnet-87654321"]
  instance_count = 1
}

# EC2モジュールを実行
run "ec2_module_validation" {
  command = plan

  module {
    source = "../../modules/ec2"
  }

  # テスト条件
  assert {
    condition     = length(aws_instance.ec2) == var.instance_count
    error_message = "EC2インスタンス数が期待値と異なります"
  }

  assert {
    condition     = aws_instance.ec2[0].instance_type == var.instance_type
    error_message = "インスタンスタイプが期待値と異なります"
  }

  assert {
    condition     = aws_instance.ec2[0].ami == var.ami
    error_message = "AMI IDが期待値と異なります"
  }
}