# Use official Python image
FROM python:3.11-slim

# Set working directory inside container
WORKDIR /app

# Install yfinance
RUN pip install --no-cache-dir yfinance

# Copy your Python script into the container
COPY population.py .

# Run the script
CMD ["python", "population.py"]

