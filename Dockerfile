# Use official Python image
FROM python:3.12-slim

WORKDIR /app

# Install Poetry
RUN pip install --no-cache-dir poetry

# Copy only dependency files for caching
COPY pyproject.toml poetry.lock* /app/

# Install dependencies (Poetry 2.x syntax)
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --without dev

# Copy application code
COPY . /app

# Expose Dash port
EXPOSE 8050

# Run Gunicorn with preload + async threads
CMD ["gunicorn", "app:server", \
     "--bind", "0.0.0.0:8050", \
     "--workers", "2", \
     "--threads", "4", \
     "--timeout", "120", \
     "--preload", \
     "--worker-class", "gthread"]

