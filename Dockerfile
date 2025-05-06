FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p static staticfiles

RUN python manage.py collectstatic --noinput

# Create directory for SSL certificates
RUN mkdir -p /app/certs

# Copy SSL certificates (they will be mounted at runtime)
VOLUME ["/app/certs"]

CMD ["gunicorn", "--bind", "0.0.0.0:443", "--workers", "3", "--certfile", "/app/certs/cert.pem", "--keyfile", "/app/certs/key.pem", "AUP.wsgi:application"]
