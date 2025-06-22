#!/bin/bash

# VSCode Self-Host Start Script
echo "🚀 Starting VSCode Self-Host with Code-Server..."

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Creating from .env.example..."
    cp .env.example .env
    echo "📝 Please edit .env file to set your passwords before running again."
    exit 1
fi

# Load environment variables
source .env

# Create directories if they don't exist
mkdir -p config data extensions

# Set proper permissions
echo "🔧 Setting up permissions..."
sudo chown -R 1000:1000 config data extensions

# Start docker compose
echo "🐳 Starting Docker containers..."
docker-compose up -d

# Wait a moment for container to start
sleep 5

# Check if container is running
if docker-compose ps | grep -q "Up"; then
    echo "✅ VSCode Self-Host is running!"
    echo "🌐 Access your VSCode at: http://localhost:8080"
    echo "🔑 Default password: Check your .env file"

    # Auto-setup GitHub Copilot if enabled
    if [ "${ENABLE_COPILOT:-false}" = "true" ]; then
        echo ""
        echo "🤖 ENABLE_COPILOT=true detected. Setting up GitHub Copilot..."
        echo "⏳ This may take a few moments..."

        # Wait a bit more for container to be fully ready
        sleep 5

        # Run Copilot setup
        if [ -f "./scripts/setup-copilot.sh" ]; then
            ./scripts/setup-copilot.sh
        else
            echo "⚠️  setup-copilot.sh not found. Skipping Copilot setup."
        fi
    else
        echo ""
        echo "💡 Tip: Set ENABLE_COPILOT=true in .env to auto-setup GitHub Copilot"
        echo "   Or run manually: ./scripts/setup-copilot.sh"
    fi

    echo ""
    echo "📋 Useful commands:"
    echo "  - Stop: ./scripts/stop.sh"
    echo "  - View logs: docker-compose logs -f"
    echo "  - Restart: docker-compose restart"
    echo "  - Setup Copilot: ./scripts/setup-copilot.sh"
else
    echo "❌ Failed to start VSCode Self-Host"
    echo "📋 Check logs with: docker-compose logs"
fi
