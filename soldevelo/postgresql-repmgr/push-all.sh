#!/bin/bash
# Copyright 2026 SolDevelo
# SPDX-License-Identifier: Apache-2.0
#
# Push all PostgreSQL HA images to Docker Hub

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Image name
IMAGE_NAME="soldevelo/postgresql-repmgr"

# PostgreSQL major versions
VERSIONS=(12 13 14 15 16 17 18)

# Latest version
LATEST_VERSION="18"

echo "========================================"
echo "Pushing PostgreSQL HA images"
echo "========================================"
echo ""

# Check if user is logged in to Docker Hub
if ! docker info | grep -q "Username"; then
    echo "WARNING: You may not be logged in to Docker Hub"
    echo "Run 'docker login' if push fails"
    echo ""
fi

for MAJOR_VERSION in "${VERSIONS[@]}"; do
    BUILD_DIR="${MAJOR_VERSION}/debian-12"
    
    if [ ! -d "$BUILD_DIR" ]; then
        echo "WARNING: Build directory $BUILD_DIR does not exist, skipping..."
        continue
    fi
    
    # Extract full version from Dockerfile
    DOCKERFILE="${BUILD_DIR}/Dockerfile"
    if [ ! -f "$DOCKERFILE" ]; then
        echo "WARNING: Dockerfile not found at $DOCKERFILE, skipping..."
        continue
    fi
    
    FULL_VERSION=$(grep 'org.opencontainers.image.version=' "$DOCKERFILE" | sed -n 's/.*org.opencontainers.image.version="\([^"]*\)".*/\1/p')
    
    if [ -z "$FULL_VERSION" ]; then
        echo "WARNING: Could not extract version from $DOCKERFILE, skipping..."
        continue
    fi
    
    echo "----------------------------------------"
    echo "Pushing PostgreSQL HA $FULL_VERSION"
    echo "----------------------------------------"
    
    # Push full version
    echo "Pushing ${IMAGE_NAME}:${FULL_VERSION}..."
    docker push "${IMAGE_NAME}:${FULL_VERSION}"
    
    # Push major version tag
    echo "Pushing ${IMAGE_NAME}:${MAJOR_VERSION}..."
    docker push "${IMAGE_NAME}:${MAJOR_VERSION}"
    
    # Push latest tag if this is the latest version
    if [ "$MAJOR_VERSION" = "$LATEST_VERSION" ]; then
        echo "Pushing ${IMAGE_NAME}:latest..."
        docker push "${IMAGE_NAME}:latest"
    fi
    
    echo "✓ Push complete for version $FULL_VERSION"
    echo ""
done

echo "========================================"
echo "All images pushed successfully!"
echo "========================================"
echo ""
echo "To flatten images, run: ./flatten-all.sh"
