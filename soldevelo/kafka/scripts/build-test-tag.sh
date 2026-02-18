#!/bin/bash
# Copyright 2026 SolDevelo
# SPDX-License-Identifier: Apache-2.0
#
# Build, test, and tag Kafka image for any version

set -e

# Parse arguments
VERSION=""
IS_LATEST=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --version)
            VERSION="$2"
            shift 2
            ;;
        --latest)
            IS_LATEST=true
            shift
            ;;
        *)
            echo "Usage: $0 --version <version> [--latest]"
            echo "  --version  Kafka version (e.g., 4.1.1, 3.4.1)"
            echo "  --latest   Tag this build as 'latest'"
            exit 1
            ;;
    esac
done

if [ -z "$VERSION" ]; then
    echo "ERROR: --version is required"
    echo "Usage: $0 --version <version> [--latest]"
    exit 1
fi

# Extract major version (e.g., 4.1.1 -> 4.1)
MAJOR_VERSION=$(echo "$VERSION" | cut -d. -f1,2)

# Determine build directory
BUILD_DIR="$MAJOR_VERSION/debian-12"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KAFKA_ROOT="$(dirname "$SCRIPT_DIR")"

if [ ! -d "$KAFKA_ROOT/$BUILD_DIR" ]; then
    echo "ERROR: Build directory $BUILD_DIR does not exist"
    exit 1
fi

cd "$KAFKA_ROOT/$BUILD_DIR"

# Configuration
IMAGE_NAME="soldevelo/kafka"
CONTAINER_NAME="kafka-test-$$"

echo "================================================="
echo "Building Kafka ${VERSION} image..."
echo "================================================="
docker build -t "${IMAGE_NAME}:${MAJOR_VERSION}" .

echo ""
echo "================================================="
echo "Tagging image..."
echo "================================================="

# Tag the full version
docker tag "${IMAGE_NAME}:${MAJOR_VERSION}" "${IMAGE_NAME}:${VERSION}"
echo "✓ Tagged as ${IMAGE_NAME}:${VERSION}"
echo "✓ Tagged as ${IMAGE_NAME}:${MAJOR_VERSION}"

# Tag as latest if requested
if [ "$IS_LATEST" = true ]; then
    docker tag "${IMAGE_NAME}:${MAJOR_VERSION}" "${IMAGE_NAME}:latest"
    echo "✓ Tagged as ${IMAGE_NAME}:latest"
fi

echo ""
echo "================================================="
echo "Testing Kafka ${VERSION} image..."
echo "================================================="

# Start container using docker-compose
echo "Starting Kafka container with docker-compose..."
docker-compose down -v
docker-compose up -d

# Wait for Kafka to start
echo "Waiting for Kafka to start..."
sleep 40

# Get container name from docker-compose
COMPOSE_CONTAINER=$(docker-compose ps -q kafka)
if [ -z "$COMPOSE_CONTAINER" ]; then
    echo "ERROR: Could not find container from docker-compose"
    docker-compose logs
    docker-compose down -v
    exit 1
fi

CONTAINER_NAME=$(docker inspect --format='{{.Name}}' "$COMPOSE_CONTAINER" | sed 's/^\///')

# Check if container is running
if ! docker ps | grep -q "${CONTAINER_NAME}"; then
    echo "ERROR: Container failed to start"
    docker logs "${CONTAINER_NAME}" 2>&1 | tail -50
    docker-compose down -v
    exit 1
fi

# Check logs for successful startup
echo "Checking startup logs..."
if ! docker logs "${CONTAINER_NAME}" 2>&1 | grep -q "Kafka Server started"; then
    echo "ERROR: Kafka did not start successfully"
    docker logs "${CONTAINER_NAME}" 2>&1 | tail -50
    docker-compose down -v
    exit 1
fi

echo "✓ Kafka started successfully"

# Create test topic
echo "Creating test topic..."
docker exec "${CONTAINER_NAME}" kafka-topics.sh \
    --create \
    --topic test-topic \
    --bootstrap-server localhost:9092 \
    --partitions 1 \
    --replication-factor 1

echo "✓ Topic created"

# Produce messages
echo "Producing test messages..."
echo -e "Test message 1\nTest message 2\nTest message 3" | \
    docker exec -i "${CONTAINER_NAME}" kafka-console-producer.sh \
        --topic test-topic \
        --bootstrap-server localhost:9092

echo "✓ Messages produced"

# Consume messages
echo "Consuming messages..."
CONSUMED=$(docker exec "${CONTAINER_NAME}" kafka-console-consumer.sh \
    --topic test-topic \
    --from-beginning \
    --bootstrap-server localhost:9092 \
    --max-messages 3 \
    --timeout-ms 10000 2>/dev/null | grep "Test message" | wc -l)

if [ "$CONSUMED" -ne 3 ]; then
    echo "ERROR: Expected 3 messages, consumed $CONSUMED"
    docker-compose down -v
    exit 1
fi

echo "✓ Messages consumed successfully"

# Verify version
echo "Verifying Kafka version..."
KAFKA_VERSION=$(docker logs "${CONTAINER_NAME}" 2>&1 | grep "Kafka version:" | tail -1 | awk '{print $NF}')
if [ "$KAFKA_VERSION" != "$VERSION" ]; then
    echo "WARNING: Expected version ${VERSION}, found ${KAFKA_VERSION}"
fi
echo "✓ Kafka version: ${KAFKA_VERSION}"

# Cleanup
echo "Cleaning up test container..."
docker-compose down -v

echo ""
echo "================================================="
echo "Build, test, and tag completed successfully!"
echo "================================================="
echo ""
echo "Available tags:"
docker images "${IMAGE_NAME}" --format "table {{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.Size}}" | head -5
