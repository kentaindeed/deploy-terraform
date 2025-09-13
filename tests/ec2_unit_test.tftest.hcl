# EC2モジュールの単体テスト

run "ec2_module_validation" {
  command = plan
  
  module {
    source = "../modules/ec2"
  }

  variables {
    ami            = "ami-047126e50991d067b"
    instance_type  = "t2.micro"
    subnet_ids     = ["subnet-12345678", "subnet-87654321"]
    instance_count = 2
  }

  # インスタンス数のテスト
  assert {
    condition     = length(aws_instance.ec2) == 2
    error_message = "EC2インスタンス数が期待値と異なります"
  }

  # インスタンスタイプのテスト
  assert {
    condition     = aws_instance.ec2[0].instance_type == "t2.micro"
    error_message = "インスタンスタイプが期待値と異なります"
  }

  # AMI IDのテスト
  assert {
    condition     = aws_instance.ec2[0].ami == "ami-047126e50991d067b"
    error_message = "AMI IDが期待値と異なります"
  }

  # タグのテスト
  assert {
    condition     = aws_instance.ec2[0].tags["Project"] == "terraform-project"
    error_message = "Projectタグが期待値と異なります"
  }

  # サブネット配置のテスト
  assert {
    condition     = contains(["subnet-12345678", "subnet-87654321"], aws_instance.ec2[0].subnet_id)
    error_message = "EC2インスタンスが指定されたサブネットに配置されていません"
  }
}