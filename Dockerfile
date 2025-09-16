# Stage 1: Builder
FROM --platform=$BUILDPLATFORM python:3.12-alpine AS builder

# Build dependencies
RUN apk add --no-cache --virtual .build-deps \
        build-base \
        linux-headers \
        libffi-dev \
        git \
        bash \
        curl

# Install Poetry
RUN pip install --no-cache-dir poetry

WORKDIR /app

# Copy dependency files first (for caching)
COPY pyproject.toml poetry.lock /app/

# Install dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --without dev --no-interaction

# Stage 2: Final image
FROM python:3.12-alpine

WORKDIR /app

# Runtime dependencies only
RUN apk add --no-cache bash libffi

# Copy installed dependencies
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy application code
COPY app.py /app/

# Expose Dash port
EXPOSE 8050

# Run Gunicorn
CMD ["gunicorn", "app:server", \
     "--bind", "0.0.0.0:8050", \
     "--workers", "2", \
     "--threads", "4", \
     "--timeout", "120", \
     "--preload", \
     "--worker-class", "gthread"]

