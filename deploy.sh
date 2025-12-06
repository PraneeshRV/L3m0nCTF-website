#!/bin/bash

# L3m0nCTF Deployment Script
# Usage: ./deploy.sh [tag]

echo "🍋 Starting L3m0nCTF Deployment..."

# 1. Pull latest changes (if using git)
# git pull origin main

# 2. Stop existing containers
echo "Stopping containers..."
docker-compose down

# 3. Build and Start
echo "Building and Starting services..."
docker-compose up -d --build

# 4. Prune unused images to save space (important for small VMs)
echo "Cleaning up..."
docker image prune -f

echo "✅ Deployment Complete!"
echo "Check logs with: docker-compose logs -f"
