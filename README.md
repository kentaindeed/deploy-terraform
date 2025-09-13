# これは何

Terraform でCICD の練習をするためのレポジトリになります。

## MCP server
terraform のMCP server を設定しています。

```bash
{
  "mcpServers": {
    "terraform": {
      "command": "uvx",
      "args": ["terraform-mcp-server@latest"],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "disabled": false,
      "autoApprove": []
    }
  }
}

```