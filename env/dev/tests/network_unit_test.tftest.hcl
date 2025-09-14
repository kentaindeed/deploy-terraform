# Networkモジュールの単体テスト

run "network_module_validation" {
  command = plan

  module {
    source = "../../modules/network"
  }

  # VPC設定のテスト
  assert {
    condition     = aws_vpc.main.cidr_block == "10.0.0.0/16"
    error_message = "VPC CIDRブロックが期待値と異なります"
  }

  # DNS設定のテスト
  assert {
    condition     = aws_vpc.main.enable_dns_hostnames == true
    error_message = "DNS hostnames設定が期待値と異なります"
  }

  assert {
    condition     = aws_vpc.main.enable_dns_support == true
    error_message = "DNS support設定が期待値と異なります"
  }

  # パブリックサブネット数のテスト
  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "パブリックサブネット数が期待値と異なります"
  }

  # プライベートサブネット数のテスト
  assert {
    condition     = length(aws_subnet.private) == 2
    error_message = "プライベートサブネット数が期待値と異なります"
  }

  # パブリックサブネットCIDRのテスト
  assert {
    condition     = aws_subnet.public[0].cidr_block == "10.0.0.0/24"
    error_message = "パブリックサブネット0のCIDRブロックが期待値と異なります"
  }

  assert {
    condition     = aws_subnet.public[1].cidr_block == "10.0.1.0/24"
    error_message = "パブリックサブネット1のCIDRブロックが期待値と異なります"
  }

  # プライベートサブネットCIDRのテスト
  assert {
    condition     = aws_subnet.private[0].cidr_block == "10.0.10.0/24"
    error_message = "プライベートサブネット0のCIDRブロックが期待値と異なります"
  }

  assert {
    condition     = aws_subnet.private[1].cidr_block == "10.0.11.0/24"
    error_message = "プライベートサブネット1のCIDRブロックが期待値と異なります"
  }

  # CIDRブロック重複チェック
  assert {
    condition = aws_subnet.public[0].cidr_block != aws_subnet.private[0].cidr_block
    error_message = "サブネットのCIDRブロックが重複しています"
  }

  # インターネットゲートウェイのテスト
  assert {
    condition     = aws_internet_gateway.main.vpc_id == aws_vpc.main.id
    error_message = "インターネットゲートウェイが正しいVPCに関連付けられていません"
  }
}
