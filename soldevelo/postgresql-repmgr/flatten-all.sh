#!/bin/bash
# Copyright 2026 SolDevelo
# SPDX-License-Identifier: Apache-2.0
#
# Flatten all PostgreSQL HA images using crane

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Image name
IMAGE_NAME="soldevelo/postgresql-repmgr"

# PostgreSQL major versions
VERSIONS=(12 13 14 15 16 17 18)

# Latest version
LATEST_VERSION="18"

# Check if crane is installed
if ! command -v crane &> /dev/null; then
    echo "ERROR: crane is not installed"
    echo "Install it with: go install github.com/google/go-containerregistry/cmd/crane@latest"
    echo "Or download from: https://github.com/google/go-containerregistry/releases"
    exit 1
fi

echo "========================================"
echo "Flattening PostgreSQL HA images"
echo "========================================"
echo ""

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
    echo "Flattening PostgreSQL HA $FULL_VERSION"
    echo "----------------------------------------"
    
    # Flatten full version
    echo "Flattening ${IMAGE_NAME}:${FULL_VERSION}..."
    crane flatten "${IMAGE_NAME}:${FULL_VERSION}"
    
    # Flatten major version tag
    echo "Flattening ${IMAGE_NAME}:${MAJOR_VERSION}..."
    crane flatten "${IMAGE_NAME}:${MAJOR_VERSION}"
    
    # Flatten latest tag if this is the latest version
    if [ "$MAJOR_VERSION" = "$LATEST_VERSION" ]; then
        echo "Flattening ${IMAGE_NAME}:latest..."
        crane flatten "${IMAGE_NAME}:latest"
    fi
    
    echo "✓ Flatten complete for version $FULL_VERSION"
    echo ""
done

echo "========================================"
echo "All images flattened successfully!"
echo "========================================"
