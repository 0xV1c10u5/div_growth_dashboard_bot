# AI Fluff (Replace)

# Flask-SQLite App with Poetry & Docker

A simple Flask application with an embedded SQLite database, fully integrated with **Poetry** for dependency management, and optionally runnable via **Docker**. The project includes a single entry point `run.sh` that handles both Docker and native execution.

---

## Features

- Flask web application
- SQLite database with persistent `db/` folder
- Unified `run.sh` for both Docker and native execution
- Poetry-managed dependencies and virtual environment
- Configurable via optional `.env` file
- Docker support with persistent volumes
- Plug-and-play for contributors

---

## Quick Start

1. **Clone the repository**
```bash
git clone <repo-url>
cd flask-app
Run the application

bash
Copy code
./run.sh
If Docker is installed, the app runs in a container with SQLite persisted in db/.

If Docker is not installed, the app runs natively via Poetry in a virtual environment.

run.sh automatically installs Poetry on the native host if missing.

Optional Configuration
You can create a .env file to override default settings:

env
Copy code
# Flask
FLASK_APP=app.py
FLASK_ENV=development
FLASK_RUN_PORT=5000

# Docker
DOCKER_IMAGE_NAME=flask-sqlite-app
DOCKER_CONTAINER_NAME=my_flask_app
DOCKER_DETACHED=false
DOCKER_PORT_MAPPING=5000:5000
DOCKER_VOLUME_MAPPING=./db:/usr/src/app/db
The .env file is automatically loaded by run.sh.

Running with Docker
Build the Docker image

bash
Copy code
docker build -t flask-sqlite-app .
Run the Docker container

bash
Copy code
docker run -p 5000:5000 -v ./db:/usr/src/app/db flask-sqlite-app
run.sh automates this process if Docker is installed.

Running Natively (without Docker)
Ensure Poetry is installed:

bash
Copy code
curl -sSL https://install.python-poetry.org | python3 -
poetry --version
Install dependencies (optional, run.sh can do this automatically):

bash
Copy code
poetry install
Run Flask:

bash
Copy code
poetry run flask run --host 0.0.0.0 --port 5000
Or simply:

bash
Copy code
./run.sh
Detects Docker absence and runs natively.

Notes
run.sh is executable by default (Git tracks the executable bit).

SQLite database persists in db/app.db across runs.

Works cross-platform: Linux/macOS natively, Windows via Git Bash or WSL.

Docker users don’t need to manage ports or volumes manually.

Native runs automatically install Poetry if missing.

Quick Commands Reference
Action	Command
Run app	./run.sh
Run Flask locally with Poetry	poetry run flask run
Build Docker image	docker build -t flask-sqlite-app .
Run Docker container	docker run -p 5000:5000 -v ./db:/usr/src/app/db flask-sqlite-app

Summary
This repository is fully plug-and-play:

Single-entry-point: ./run.sh

Runs Docker container or native Flask automatically

Persistent SQLite database

Optional .env configuration

Contributors can start immediately after cloning with zero manual setup
