#!/bin/bash

# Script to install GitHub Copilot for code-server
echo "🤖 Installing GitHub Copilot for VSCode Self-Host..."

CONTAINER_NAME="vscode-selfhost"
COPILOT_VERSION="latest"
COPILOT_CHAT_VERSION="latest"

# Check if container is running
if ! docker ps | grep -q $CONTAINER_NAME; then
    echo "❌ Container $CONTAINER_NAME is not running. Please start it first with ./scripts/start.sh"
    exit 1
fi

# Create temporary directory for downloads
TEMP_DIR="/tmp/copilot-install"
mkdir -p $TEMP_DIR

echo "📥 Downloading GitHub Copilot extensions..."

# Download GitHub Copilot extension
echo "Downloading GitHub Copilot..."
curl -L "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/copilot/latest/vspackage" \
    -o "$TEMP_DIR/github.copilot.vsix"

# Download GitHub Copilot Chat extension
echo "Downloading GitHub Copilot Chat..."
curl -L "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/copilot-chat/latest/vspackage" \
    -o "$TEMP_DIR/github.copilot-chat.vsix"

# Copy extensions to container
echo "📦 Installing extensions in container..."
docker cp "$TEMP_DIR/github.copilot.vsix" $CONTAINER_NAME:/tmp/
docker cp "$TEMP_DIR/github.copilot-chat.vsix" $CONTAINER_NAME:/tmp/

# Install extensions
echo "Installing GitHub Copilot..."
docker exec $CONTAINER_NAME code-server --install-extension /tmp/github.copilot.vsix

echo "Installing GitHub Copilot Chat..."
docker exec $CONTAINER_NAME code-server --install-extension /tmp/github.copilot-chat.vsix

# Clean up
echo "🧹 Cleaning up..."
rm -rf $TEMP_DIR
docker exec $CONTAINER_NAME rm -f /tmp/github.copilot.vsix /tmp/github.copilot-chat.vsix

echo ""
echo "✅ GitHub Copilot installation completed!"
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
