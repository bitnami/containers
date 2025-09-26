#!/bin/bash

# Redis Failover Script
# This script tries to start the Bitnami Redis first, and falls back to superset-redis if unavailable

echo "🚀 Starting Redis with failover support..."

# Function to check if image exists locally or can be pulled
check_image() {
    local image=$1
    echo "📋 Checking availability of image: $image"
    
    # Try to pull the image
    if docker pull "$image" &>/dev/null; then
        echo "✅ Image $image is available"
        return 0
    else
        echo "❌ Image $image not available"
        return 1
    fi
}

# Function to start service and check if it's healthy
start_and_check() {
    local profile=$1
    local service_name=$2
    echo "🔄 Starting Redis with profile: $profile"
    
    # Start the service
    docker compose --profile "$profile" up -d
    
    # Wait a bit for the service to start
    sleep 5
    
    # Check if Redis is responding
    if docker compose exec "$service_name" redis-cli ping &>/dev/null || \
       docker compose exec "$service_name" /opt/bitnami/bin/redis-cli ping &>/dev/null; then
        echo "✅ Redis is running and responding on profile: $profile"
        return 0
    else
        echo "❌ Redis failed to start properly on profile: $profile"
        docker compose --profile "$profile" down &>/dev/null
        return 1
    fi
}

# Stop any running services first
echo "🛑 Stopping any existing Redis services..."
docker compose down &>/dev/null

# Try Bitnami Redis first
echo "🥇 Attempting to start Bitnami Redis..."
if check_image "docker.io/bitnami/redis:8.2" && start_and_check "bitnami" "redis"; then
    echo "🎉 Successfully started Bitnami Redis!"
    exit 0
fi

# Fall back to superset-redis
echo "🥈 Falling back to superset-redis..."
if check_image "felipemoreira1/superset-redis:1.0" && start_and_check "fallback" "redis-fallback"; then
    echo "🎉 Successfully started superset-redis as fallback!"
    exit 0
fi

# If both fail
echo "💥 Both Redis images failed to start. Please check your configuration."
exit 1