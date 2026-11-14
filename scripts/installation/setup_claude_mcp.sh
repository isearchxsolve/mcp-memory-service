#!/bin/bash

echo "=================================================="

# Get the absolute path to the repository
REPO_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_PYTHON="$REPO_PATH/venv/bin/python"

echo "Repository path: $REPO_PATH"
echo "Python path: $VENV_PYTHON"

# Check if virtual environment exists
if [ ! -f "$VENV_PYTHON" ]; then
    echo "❌ Virtual environment not found at: $VENV_PYTHON"
    echo "Please run: python -m venv venv && source venv/bin/activate && pip install -r requirements.txt"
    exit 1
fi

# Create MCP configuration
cat > "$REPO_PATH/mcp_server_config.json" << EOF
{
  "mcpServers": {
    "memory": {
      "command": "$VENV_PYTHON",
      "args": ["-m", "mcp_memory_service.server"],
      "cwd": "$REPO_PATH",
      "env": {
        "MCP_MEMORY_STORAGE_BACKEND": "sqlite_vec",
        "PYTHONPATH": "$REPO_PATH/src"
      }
    }
  }
}
EOF

echo "✅ Created MCP configuration: $REPO_PATH/mcp_server_config.json"
echo ""
echo "📋 Manual Configuration Steps:"
echo "1. Copy the configuration below"
echo ""
echo "Configuration to add:"
echo "====================="
cat "$REPO_PATH/mcp_server_config.json"
echo ""
echo "   cd $REPO_PATH"
echo "   source venv/bin/activate"
echo "   export MCP_MEMORY_STORAGE_BACKEND=sqlite_vec"
echo "   python -m mcp_memory_service.server"