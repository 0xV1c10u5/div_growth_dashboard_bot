#!/usr/bin/env bash
set -e

# Auto-install Poetry if missing (native host)
if ! command -v poetry >/dev/null 2>&1; then
    echo "Poetry not found. Installing..."
    curl -sSL https://install.python-poetry.org | python3 -
    export PATH="$HOME/.local/bin:$PATH"
fi

# Load .env if present
[ -f .env ] && export $(grep -v '^#' .env | xargs)

# Ensure project root
cd "$(dirname "$0")"

# Create SQLite db directory
mkdir -p db

# Defaults
FLASK_APP="${FLASK_APP:-app.py}"
FLASK_ENV="${FLASK_ENV:-development}"
FLASK_RUN_HOST="${FLASK_RUN_HOST:-0.0.0.0}"
FLASK_RUN_PORT="${FLASK_RUN_PORT:-5000}"

DOCKER_IMAGE_NAME="${DOCKER_IMAGE_NAME:-flask-sqlite-app}"
DOCKER_CONTAINER_NAME="${DOCKER_CONTAINER_NAME:-flask_app_container}"
DOCKER_PORT_MAPPING="${DOCKER_PORT_MAPPING:-$FLASK_RUN_PORT:$FLASK_RUN_PORT}"
DOCKER_VOLUME_MAPPING="${DOCKER_VOLUME_MAPPING:-$(pwd)/db:/usr/src/app/db}"
DOCKER_DETACHED="${DOCKER_DETACHED:-false}"

# Run Flask natively via Poetry
run_flask_natively() {
    echo "Running Flask natively with Poetry..."
    poetry run flask run --host "$FLASK_RUN_HOST" --port "$FLASK_RUN_PORT"
}

# Run Flask inside Docker
run_flask_in_docker() {
    echo "Docker detected! Running Flask inside Docker..."
    docker build -t "$DOCKER_IMAGE_NAME" .
    DOCKER_RUN_OPTS="-p $DOCKER_PORT_MAPPING -v $DOCKER_VOLUME_MAPPING --name $DOCKER_CONTAINER_NAME"
    [ "$DOCKER_DETACHED" = "true" ] && DOCKER_RUN_OPTS="$DOCKER_RUN_OPTS -d" || DOCKER_RUN_OPTS="$DOCKER_RUN_OPTS --rm -it"
    docker run $DOCKER_RUN_OPTS "$DOCKER_IMAGE_NAME"
}

# Detect Docker
command -v docker >/dev/null 2>&1 && run_flask_in_docker || run_flask_natively

