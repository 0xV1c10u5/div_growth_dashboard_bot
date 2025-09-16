FROM python:3.12-slim

# Install system dependencies for Poetry
RUN apt-get update && apt-get install -y curl build-essential

# Install Poetry
ENV POETRY_HOME="/opt/poetry"
ENV PATH="$POETRY_HOME/bin:$PATH"

RUN curl -sSL https://install.python-poetry.org | python3 -

WORKDIR /usr/src/app

# Copy project files
COPY pyproject.toml poetry.lock* ./
COPY . .

# Install dependencies with Poetry
RUN poetry install --no-root --no-dev

# Make run.sh executable
RUN chmod +x run.sh

EXPOSE 5000
VOLUME ["/usr/src/app/db"]

# Unified entry point
CMD ["./run.sh"]

