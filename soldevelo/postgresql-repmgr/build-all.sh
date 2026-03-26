#!/bin/bash
# Copyright 2026 SolDevelo
# SPDX-License-Identifier: Apache-2.0
#
# Build all PostgreSQL HA images

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Image name
IMAGE_NAME="soldevelo/postgresql-repmgr"

# PostgreSQL major versions to build
VERSIONS=(12 13 14 15 16 17 18)

# Latest version
LATEST_VERSION="18"

echo "========================================"
echo "Building PostgreSQL HA images"
echo "========================================"
echo ""

for MAJOR_VERSION in "${VERSIONS[@]}"; do
    BUILD_DIR="${MAJOR_VERSION}/debian-12"
    
    if [ ! -d "$BUILD_DIR" ]; then
        echo "ERROR: Build directory $BUILD_DIR does not exist, skipping..."
        continue
    fi
    
    # Extract full version from Dockerfile
    DOCKERFILE="${BUILD_DIR}/Dockerfile"
    if [ ! -f "$DOCKERFILE" ]; then
        echo "ERROR: Dockerfile not found at $DOCKERFILE, skipping..."
        continue
    fi
    
    FULL_VERSION=$(grep 'org.opencontainers.image.version=' "$DOCKERFILE" | sed -n 's/.*org.opencontainers.image.version="\([^"]*\)".*/\1/p')
    
    if [ -z "$FULL_VERSION" ]; then
        echo "ERROR: Could not extract version from $DOCKERFILE, skipping..."
        continue
    fi
    
    echo "----------------------------------------"
    echo "Building PostgreSQL HA $FULL_VERSION (major: $MAJOR_VERSION)"
    echo "----------------------------------------"
    
    cd "$BUILD_DIR"
    
    # Build the image
    echo "Building image..."
    docker build -t "${IMAGE_NAME}:${FULL_VERSION}" .
    
    # Tag with major version
    echo "Tagging as ${IMAGE_NAME}:${MAJOR_VERSION}..."
    docker tag "${IMAGE_NAME}:${FULL_VERSION}" "${IMAGE_NAME}:${MAJOR_VERSION}"
    
    # Tag as latest if this is the latest version
    if [ "$MAJOR_VERSION" = "$LATEST_VERSION" ]; then
        echo "Tagging as ${IMAGE_NAME}:latest..."
        docker tag "${IMAGE_NAME}:${FULL_VERSION}" "${IMAGE_NAME}:latest"
    fi
    
    cd "$SCRIPT_DIR"
    
    echo "✓ Build complete for version $FULL_VERSION"
    echo ""
done

echo "========================================"
echo "All builds completed successfully!"
echo "========================================"
echo ""
echo "Built images:"
docker images "${IMAGE_NAME}" --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
echo ""
echo "To push images, run: ./push-all.sh"
