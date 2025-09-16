#!/bin/bash

APP_NAME="dash_app_container"
IMAGE_NAME="dash_app_image"

# Detect local architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    PLATFORM="linux/amd64"
elif [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
    PLATFORM="linux/arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

echo "Building Docker image for local platform: $PLATFORM"
docker buildx build --platform $PLATFORM -t $IMAGE_NAME --load .

# Ensure local data folder exists for persistence
mkdir -p ./data

# Remove existing container if exists
if [ "$(docker ps -aq -f name=^/${APP_NAME}$)" ]; then
    echo "Removing existing container..."
    docker rm -f $APP_NAME
fi

# Run container with data folder mounted
echo "Starting container..."
docker run --name $APP_NAME -p 8050:8050 \
    -v $(pwd)/data:/app/data \
    $IMAGE_NAME &

CONTAINER_PID=$!
echo "Dash app running in Docker (Gunicorn). Press Ctrl+C to stop..."

# Graceful shutdown
cleanup() {
    echo ""
    echo "Stopping container..."
    docker stop $APP_NAME
    echo "Removing container..."
    docker rm $APP_NAME
    exit 0
}

trap cleanup SIGINT
wait $CONTAINER_PID

