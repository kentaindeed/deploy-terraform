# dev環境の統合テスト

# dev環境の変数を使用
variables {
  ami            = "ami-047126e50991d067b"
  instance_type  = "t2.micro"
  instance_count = 1
}

run "dev_environment_test" {
  command = plan

  # dev環境全体をテスト
  assert {
    condition     = length(module.ec2.aws_instance.ec2) == var.instance_count
    error_message = "dev環境のEC2インスタンス数が期待値と異なります"
  }

  assert {
    condition     = module.network.aws_vpc.main.cidr_block == "10.0.0.0/16"
    error_message = "dev環境のVPC CIDRが期待値と異なります"
  }

  # EC2がネットワークモジュールの出力を使用していることを確認
  assert {
    condition = contains(
      module.network.aws_subnet.public[*].id,
      module.ec2.aws_instance.ec2[0].subnet_id
    )
    error_message = "EC2インスタンスが正しいパブリックサブネットに配置されていません"
  }

  # 共通タグの確認
  assert {
    condition     = module.ec2.aws_instance.ec2[0].tags["Environment"] == "dev"
    error_message = "Environmentタグがdevに設定されていません"
  }

  # プロジェクトタグの確認
  assert {
    condition     = module.ec2.aws_instance.ec2[0].tags["Project"] == "terraform-project"
    error_message = "Projectタグが期待値と異なります"
  }

  # ネットワーク出力の確認
  assert {
    condition     = length(module.network.public_subnet_ids) == 2
    error_message = "パブリックサブネットの出力数が期待値と異なります"
  }

  assert {
    condition     = length(module.network.private_subnet_ids) == 2
    error_message = "プライベートサブネットの出力数が期待値と異なります"
  }
}