#!/bin/bash

# Troubleshooting script for GitHub Copilot installation issues

echo "🔍 GitHub Copilot Troubleshooting Tool..."

CONTAINER_NAME="vscode-selfhost"

# Function to check container status
check_container() {
    echo "📋 Checking container status..."
    if docker ps | grep -q $CONTAINER_NAME; then
        echo "✅ Container $CONTAINER_NAME is running"
        return 0
    else
        echo "❌ Container $CONTAINER_NAME is not running"
        echo "💡 Try running: ./scripts/start.sh"
        return 1
    fi
}

# Function to check installed extensions
check_extensions() {
    echo "📋 Checking installed extensions..."
    if ! check_container; then
        return 1
    fi
    
    echo "🔍 Listing all installed extensions:"
    docker exec $CONTAINER_NAME code-server --list-extensions
    
    echo ""
    echo "🔍 Checking for GitHub Copilot extensions:"
    if docker exec $CONTAINER_NAME code-server --list-extensions | grep -q "github.copilot"; then
        echo "✅ GitHub Copilot is installed"
    else
        echo "❌ GitHub Copilot is not installed"
    fi
    
    if docker exec $CONTAINER_NAME code-server --list-extensions | grep -q "github.copilot-chat"; then
        echo "✅ GitHub Copilot Chat is installed"
    else
        echo "❌ GitHub Copilot Chat is not installed"
    fi
}

# Function to clean up corrupted files
cleanup_corrupted() {
    echo "🧹 Cleaning up potentially corrupted files..."
    
    # Clean up local temp files
    echo "🗑️  Removing local temp files..."
    rm -rf /tmp/copilot-install
    rm -f /tmp/github.copilot*.vsix
    
    if check_container; then
        # Clean up container temp files
        echo "🗑️  Removing container temp files..."
        docker exec $CONTAINER_NAME rm -f /tmp/github.copilot*.vsix 2>/dev/null
        
        # Clean up extension cache
        echo "🗑️  Clearing extension cache..."
        docker exec $CONTAINER_NAME rm -rf /home/coder/.local/share/code-server/CachedExtensions 2>/dev/null
    fi
    
    echo "✅ Cleanup completed"
}

# Function to test network connectivity
test_network() {
    echo "🌐 Testing network connectivity..."
    
    echo "📡 Testing connection to Visual Studio Marketplace..."
    if curl -s --connect-timeout 10 "https://marketplace.visualstudio.com" > /dev/null; then
        echo "✅ Can connect to Visual Studio Marketplace"
    else
        echo "❌ Cannot connect to Visual Studio Marketplace"
        echo "💡 Check your internet connection"
        return 1
    fi
    
    echo "📡 Testing GitHub API..."
    if curl -s --connect-timeout 10 "https://api.github.com" > /dev/null; then
        echo "✅ Can connect to GitHub API"
    else
        echo "❌ Cannot connect to GitHub API"
        echo "💡 Check your internet connection"
        return 1
    fi
}

# Main menu
show_menu() {
    echo ""
    echo "🛠️  Troubleshooting Options:"
    echo "1. Check container and extensions status"
    echo "2. Clean up corrupted files"
    echo "3. Test network connectivity"
    echo "4. Try manual installation"
    echo "5. Try improved installation script"
    echo "6. Show installation logs"
    echo "7. Exit"
    echo ""
    read -p "Choose an option (1-7): " choice
    
    case $choice in
        1)
            check_extensions
            ;;
        2)
            cleanup_corrupted
            ;;
        3)
            test_network
            ;;
        4)
            echo "🔧 Running manual installation..."
            ./scripts/install-copilot-manual.sh
            ;;
        5)
            echo "🔧 Running improved installation script..."
            ./scripts/install-copilot.sh
            ;;
        6)
            echo "📋 Showing recent Docker logs..."
            docker logs --tail 50 $CONTAINER_NAME
            ;;
        7)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid option. Please choose 1-7."
            ;;
    esac
}

# Main execution
echo "🚀 Starting troubleshooting..."
echo ""

# Run initial checks
check_container
test_network

# Show menu
while true; do
    show_menu
    echo ""
    read -p "Press Enter to continue or Ctrl+C to exit..."
done
