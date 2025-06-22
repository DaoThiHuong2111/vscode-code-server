#!/bin/bash

# Script to install GitHub Copilot for code-server with improved error handling
echo "🤖 Installing GitHub Copilot for VSCode Self-Host..."

CONTAINER_NAME="vscode-selfhost"
COPILOT_VERSION="latest"
COPILOT_CHAT_VERSION="latest"
MAX_RETRIES=3
MIN_FILE_SIZE=1000000  # Minimum 1MB for a valid extension

# Function to validate zip file
validate_zip() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "❌ File $file does not exist"
        return 1
    fi

    local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    if [ "$size" -lt "$MIN_FILE_SIZE" ]; then
        echo "❌ File $file is too small ($size bytes). Expected at least $MIN_FILE_SIZE bytes"
        return 1
    fi

    # Test if it's a valid zip file
    if ! unzip -t "$file" >/dev/null 2>&1; then
        echo "❌ File $file is not a valid zip file"
        return 1
    fi

    echo "✅ File $file is valid (size: $size bytes)"
    return 0
}

# Function to download with retry
download_with_retry() {
    local url="$1"
    local output="$2"
    local description="$3"

    for i in $(seq 1 $MAX_RETRIES); do
        echo "📥 Downloading $description (attempt $i/$MAX_RETRIES)..."

        # Remove existing file if it exists
        [ -f "$output" ] && rm -f "$output"

        # Download with progress and better error handling
        if curl -L --fail --show-error --progress-bar \
            --connect-timeout 30 \
            --max-time 300 \
            "$url" -o "$output"; then

            # Validate the downloaded file
            if validate_zip "$output"; then
                echo "✅ Successfully downloaded $description"
                return 0
            else
                echo "⚠️  Downloaded file is invalid, retrying..."
                rm -f "$output"
            fi
        else
            echo "⚠️  Download failed, retrying..."
            rm -f "$output"
        fi

        if [ $i -lt $MAX_RETRIES ]; then
            echo "⏳ Waiting 5 seconds before retry..."
            sleep 5
        fi
    done

    echo "❌ Failed to download $description after $MAX_RETRIES attempts"
    return 1
}

# Check if container is running
if ! docker ps | grep -q $CONTAINER_NAME; then
    echo "❌ Container $CONTAINER_NAME is not running. Please start it first with ./scripts/start.sh"
    exit 1
fi

# Create temporary directory for downloads
TEMP_DIR="/tmp/copilot-install"
rm -rf $TEMP_DIR  # Clean up any existing directory
mkdir -p $TEMP_DIR

echo "📥 Downloading GitHub Copilot extensions..."

# Download GitHub Copilot extension
if ! download_with_retry \
    "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/copilot/latest/vspackage" \
    "$TEMP_DIR/github.copilot.vsix" \
    "GitHub Copilot"; then
    echo "❌ Failed to download GitHub Copilot extension"
    rm -rf $TEMP_DIR
    exit 1
fi

# Download GitHub Copilot Chat extension
if ! download_with_retry \
    "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/copilot-chat/latest/vspackage" \
    "$TEMP_DIR/github.copilot-chat.vsix" \
    "GitHub Copilot Chat"; then
    echo "❌ Failed to download GitHub Copilot Chat extension"
    rm -rf $TEMP_DIR
    exit 1
fi

# Copy extensions to container
echo "📦 Installing extensions in container..."

# Copy GitHub Copilot extension
echo "📋 Copying GitHub Copilot to container..."
if ! docker cp "$TEMP_DIR/github.copilot.vsix" $CONTAINER_NAME:/tmp/; then
    echo "❌ Failed to copy GitHub Copilot extension to container"
    rm -rf $TEMP_DIR
    exit 1
fi

# Copy GitHub Copilot Chat extension
echo "📋 Copying GitHub Copilot Chat to container..."
if ! docker cp "$TEMP_DIR/github.copilot-chat.vsix" $CONTAINER_NAME:/tmp/; then
    echo "❌ Failed to copy GitHub Copilot Chat extension to container"
    rm -rf $TEMP_DIR
    exit 1
fi

# Install extensions with better error handling
echo "🔧 Installing GitHub Copilot..."
if ! docker exec $CONTAINER_NAME code-server --install-extension /tmp/github.copilot.vsix; then
    echo "❌ Failed to install GitHub Copilot extension"
    # Clean up before exit
    rm -rf $TEMP_DIR
    docker exec $CONTAINER_NAME rm -f /tmp/github.copilot.vsix /tmp/github.copilot-chat.vsix 2>/dev/null
    exit 1
fi

echo "🔧 Installing GitHub Copilot Chat..."
if ! docker exec $CONTAINER_NAME code-server --install-extension /tmp/github.copilot-chat.vsix; then
    echo "❌ Failed to install GitHub Copilot Chat extension"
    # Clean up before exit
    rm -rf $TEMP_DIR
    docker exec $CONTAINER_NAME rm -f /tmp/github.copilot.vsix /tmp/github.copilot-chat.vsix 2>/dev/null
    exit 1
fi

# Clean up
echo "🧹 Cleaning up..."
rm -rf $TEMP_DIR
docker exec $CONTAINER_NAME rm -f /tmp/github.copilot.vsix /tmp/github.copilot-chat.vsix 2>/dev/null

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
