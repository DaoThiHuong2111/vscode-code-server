#!/bin/bash

# Manual installation script for GitHub Copilot
# Use this if the main install script fails

echo "🔧 Manual GitHub Copilot Installation for VSCode Self-Host..."

CONTAINER_NAME="vscode-selfhost"

# Check if container is running
if ! docker ps | grep -q $CONTAINER_NAME; then
    echo "❌ Container $CONTAINER_NAME is not running. Please start it first with ./scripts/start.sh"
    exit 1
fi

echo "📋 Manual installation steps:"
echo "1. Installing GitHub Copilot from marketplace..."

# Install directly from marketplace using extension ID
echo "🔧 Installing GitHub Copilot..."
if docker exec $CONTAINER_NAME code-server --install-extension GitHub.copilot; then
    echo "✅ GitHub Copilot installed successfully"
else
    echo "❌ Failed to install GitHub Copilot"
    exit 1
fi

echo "🔧 Installing GitHub Copilot Chat..."
if docker exec $CONTAINER_NAME code-server --install-extension GitHub.copilot-chat; then
    echo "✅ GitHub Copilot Chat installed successfully"
else
    echo "❌ Failed to install GitHub Copilot Chat"
    exit 1
fi

echo ""
echo "✅ Manual GitHub Copilot installation completed!"
echo ""
echo "🔑 To authenticate GitHub Copilot:"
echo "1. Access VSCode at http://localhost:8080"
echo "2. Open Command Palette (Ctrl+Shift+P)"
echo "3. Type 'GitHub Copilot: Sign In'"
echo "4. Follow the authentication prompts"
echo ""
echo "📋 Alternative authentication method:"
echo "1. Click on the GitHub Copilot icon in the status bar"
echo "2. Click 'Sign in to GitHub'"
echo "3. Follow the browser authentication flow"
echo ""
echo "🚨 Important Notes:"
echo "- You need an active GitHub Copilot subscription"
echo "- Make sure you're signed in to GitHub in your browser"
echo "- If authentication fails, try restarting the container"
