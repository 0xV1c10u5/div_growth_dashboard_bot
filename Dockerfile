# Use official Python image
FROM python:3.12-slim

# Prevent Python from writing pyc files and buffer output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /usr/src/app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code and run script
COPY . .

# Make sure run.sh is executable
RUN chmod +x run.sh

# Expose Flask port
EXPOSE 5000

# Persist SQLite database
VOLUME ["/usr/src/app/db"]

# Use unified entry point
CMD ["./run.sh"]

