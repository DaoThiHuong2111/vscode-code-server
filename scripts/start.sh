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
    echo ""
    echo "📋 Useful commands:"
    echo "  - Stop: ./scripts/stop.sh"
    echo "  - View logs: docker-compose logs -f"
    echo "  - Restart: docker-compose restart"
else
    echo "❌ Failed to start VSCode Self-Host"
    echo "📋 Check logs with: docker-compose logs"
fi
