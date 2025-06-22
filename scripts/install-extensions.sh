#!/bin/bash

# Script to install popular VSCode extensions
echo "📦 Installing popular VSCode extensions..."

CONTAINER_NAME="vscode-selfhost"

# Check if container is running
if ! docker ps | grep -q $CONTAINER_NAME; then
    echo "❌ Container $CONTAINER_NAME is not running. Please start it first with ./scripts/start.sh"
    exit 1
fi

# List of popular extensions
extensions=(
    "ms-python.python"
    "ms-vscode.vscode-typescript-next"
    "esbenp.prettier-vscode"
    "ms-vscode.vscode-json"
    "bradlc.vscode-tailwindcss"
    "ms-vscode.vscode-eslint"
    "formulahendry.auto-rename-tag"
    "ms-vscode.vscode-html-css-support"
    "ritwickdey.liveserver"
    "ms-vscode.vscode-git"
)

# Install each extension
for extension in "${extensions[@]}"; do
    echo "Installing $extension..."
    docker exec $CONTAINER_NAME code-server --install-extension $extension
done

# For GitHub Copilot (requires authentication)
echo ""
echo "🤖 To install GitHub Copilot:"
echo "1. Access VSCode at http://localhost:8080"
echo "2. Go to Extensions tab"
echo "3. Search for 'GitHub Copilot'"
echo "4. Install and authenticate with your GitHub account"

echo "✅ Extensions installation completed!"
