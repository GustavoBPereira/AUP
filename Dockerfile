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

RUN mkdir -p /app/certs && \
    chmod 755 /app/certs && \
    touch /app/certs/fullchain.pem /app/certs/privkey.pem && \
    chmod 644 /app/certs/fullchain.pem /app/certs/privkey.pem

VOLUME ["/app/certs"]

EXPOSE 443

CMD ["gunicorn", "--bind", "0.0.0.0:443", "--workers", "3", "--certfile", "/app/certs/fullchain.pem", "--keyfile", "/app/certs/privkey.pem", "AUP.wsgi:application"]
