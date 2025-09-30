# Use a lightweight Python image
FROM python:3.12-slim

# Create app directory
WORKDIR /app

# Install deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy code
COPY main.py .

# Expose the port Cloud Run expects
ENV PORT=8080
# Gunicorn serves prod traffic
CMD ["gunicorn", "-b", "0.0.0.0:8080", "main:app"]
