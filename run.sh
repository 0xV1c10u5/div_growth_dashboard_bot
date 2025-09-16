#!/usr/bin/env bash
set -e

# Load .env if it exists
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Ensure script runs from the project root
cd "$(dirname "$0")"

# Create db directory for SQLite persistence
mkdir -p db

# Default values if not defined in .env
FLASK_APP="${FLASK_APP:-app.py}"
FLASK_ENV="${FLASK_ENV:-development}"
FLASK_RUN_HOST="${FLASK_RUN_HOST:-0.0.0.0}"
FLASK_RUN_PORT="${FLASK_RUN_PORT:-5000}"

DOCKER_IMAGE_NAME="${DOCKER_IMAGE_NAME:-flask-sqlite-app}"
DOCKER_CONTAINER_NAME="${DOCKER_CONTAINER_NAME:-flask_app_container}"
DOCKER_PORT_MAPPING="${DOCKER_PORT_MAPPING:-$FLASK_RUN_PORT:$FLASK_RUN_PORT}"
DOCKER_VOLUME_MAPPING="${DOCKER_VOLUME_MAPPING:-$(pwd)/db:/usr/src/app/db}"
DOCKER_DETACHED="${DOCKER_DETACHED:-false}"

# Function: run Flask natively
run_flask_natively() {
    echo "Running Flask natively..."
    export FLASK_APP FLASK_ENV FLASK_RUN_HOST FLASK_RUN_PORT
    exec flask run
}

# Function: run Flask inside Docker
run_flask_in_docker() {
    echo "Docker detected! Running Flask inside Docker..."

    # Build Docker image
    docker build -t "$DOCKER_IMAGE_NAME" .

    # Prepare run options
    DOCKER_RUN_OPTS="-p $DOCKER_PORT_MAPPING -v $DOCKER_VOLUME_MAPPING --name $DOCKER_CONTAINER_NAME"
    if [ "$DOCKER_DETACHED" = "true" ]; then
        DOCKER_RUN_OPTS="$DOCKER_RUN_OPTS -d"
    else
        DOCKER_RUN_OPTS="$DOCKER_RUN_OPTS --rm -it"
    fi

    # Run container
    docker run $DOCKER_RUN_OPTS "$DOCKER_IMAGE_NAME"
}

# Main logic: detect Docker
if command -v docker >/dev/null 2>&1; then
    run_flask_in_docker
else
    run_flask_natively
fi

