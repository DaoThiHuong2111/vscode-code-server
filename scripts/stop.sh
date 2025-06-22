#!/bin/bash

# VSCode Self-Host Stop Script
echo "🛑 Stopping VSCode Self-Host..."

# Stop docker compose
docker-compose down

echo "✅ VSCode Self-Host stopped successfully!"
echo "📋 To start again, run: ./scripts/start.sh"
