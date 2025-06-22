#!/bin/bash

# Advanced GitHub Copilot Setup Script for code-server
echo "🚀 Advanced GitHub Copilot Setup for VSCode Self-Host..."

CONTAINER_NAME="vscode-selfhost"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if container is running
check_container() {
    if ! docker ps | grep -q $CONTAINER_NAME; then
        print_error "Container $CONTAINER_NAME is not running."
        print_status "Please start the container first with ./scripts/start.sh"
        exit 1
    fi
    print_success "Container is running"
}

# Download and install Copilot extensions
install_copilot_extensions() {
    print_status "Installing GitHub Copilot extensions..."
    
    # Create extensions directory if it doesn't exist
    docker exec $CONTAINER_NAME mkdir -p /home/coder/.local/share/code-server/extensions
    
    # Install GitHub Copilot
    print_status "Installing GitHub Copilot..."
    docker exec $CONTAINER_NAME code-server --install-extension GitHub.copilot --force
    
    # Install GitHub Copilot Chat
    print_status "Installing GitHub Copilot Chat..."
    docker exec $CONTAINER_NAME code-server --install-extension GitHub.copilot-chat --force
    
    print_success "Extensions installed successfully"
}

# Configure code-server for Copilot
configure_copilot() {
    print_status "Configuring code-server for GitHub Copilot..."
    
    # Create settings.json with Copilot configuration
    docker exec $CONTAINER_NAME mkdir -p /home/coder/.local/share/code-server/User
    
    cat << 'EOF' | docker exec -i $CONTAINER_NAME tee /home/coder/.local/share/code-server/User/settings.json > /dev/null
{
    "github.copilot.enable": {
        "*": true,
        "yaml": true,
        "plaintext": true,
        "markdown": true
    },
    "github.copilot.inlineSuggest.enable": true,
    "github.copilot.chat.enabled": true,
    "extensions.autoUpdate": false,
    "extensions.autoCheckUpdates": false
}
EOF
    
    print_success "Configuration applied"
}

# Restart container to apply changes
restart_container() {
    print_status "Restarting container to apply changes..."
    docker-compose restart
    sleep 10
    print_success "Container restarted"
}

# Display authentication instructions
show_auth_instructions() {
    echo ""
    echo "🔐 GitHub Copilot Authentication Instructions:"
    echo "=============================================="
    echo ""
    echo "Method 1: Through VSCode Interface (Recommended)"
    echo "1. Open VSCode at http://localhost:8080"
    echo "2. Look for GitHub Copilot icon in the status bar (bottom right)"
    echo "3. Click on it and select 'Sign in to GitHub'"
    echo "4. Follow the browser authentication flow"
    echo ""
    echo "Method 2: Command Palette"
    echo "1. Open Command Palette (Ctrl+Shift+P or Cmd+Shift+P)"
    echo "2. Type 'GitHub Copilot: Sign In'"
    echo "3. Follow the authentication prompts"
    echo ""
    echo "Method 3: Manual VSIX Installation (If above methods fail)"
    echo "1. Download Copilot VSIX from: https://marketplace.visualstudio.com/items?itemName=GitHub.copilot"
    echo "2. In VSCode, go to Extensions view (Ctrl+Shift+X)"
    echo "3. Click '...' menu and select 'Install from VSIX...'"
    echo "4. Upload the downloaded VSIX file"
    echo ""
    echo "🚨 Troubleshooting:"
    echo "- Make sure you have an active GitHub Copilot subscription"
    echo "- Clear browser cache if authentication fails"
    echo "- Try incognito/private browsing mode"
    echo "- Restart the container if needed: docker-compose restart"
    echo ""
    print_success "Setup completed! GitHub Copilot should now be available."
}

# Main execution
main() {
    print_status "Starting GitHub Copilot setup..."
    
    check_container
    install_copilot_extensions
    configure_copilot
    restart_container
    show_auth_instructions
    
    echo ""
    print_success "GitHub Copilot setup completed successfully!"
    echo ""
    echo "🌐 Access your VSCode at: http://localhost:8080"
    echo "🤖 GitHub Copilot should now be available for authentication"
}

# Run main function
main
