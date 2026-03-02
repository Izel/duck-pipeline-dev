FROM python:3.11-slim

# Prevent Python from writing .pyc files and enable unbuffered logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN apt-get update && apt-get install -y gcc
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# main refers to main.py, app refers to the Flask instance
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app

# Run the pipeline
#CMD ["python", "connect.py"]