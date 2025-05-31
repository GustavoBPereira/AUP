FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    nginx \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p static staticfiles

RUN python manage.py collectstatic --noinput

RUN mkdir -p /app/certs && \
    chmod 755 /app/certs

# Configure Nginx
RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/sites-available/default

RUN echo "server { \
    listen 80; \
    server_name _; \
    return 301 https://\$host\$request_uri; \
}" > /etc/nginx/conf.d/default.conf

RUN echo "server { \
    listen 443 ssl; \
    server_name _; \
    ssl_certificate /etc/letsencrypt/live/aup.rec.br/fullchain.pem; \
    ssl_certificate_key /etc/letsencrypt/live/aup.rec.br/privkey.pem; \
    location / { \
        proxy_pass http://localhost:8000; \
        proxy_set_header Host \$host; \
        proxy_set_header X-Real-IP \$remote_addr; \
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for; \
        proxy_set_header X-Forwarded-Proto \$scheme; \
    } \
}" >> /etc/nginx/conf.d/default.conf

# Create nginx user if it doesn't exist
RUN useradd -r nginx || true

# Set proper permissions
RUN chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /var/lib/nginx && \
    chmod -R 755 /var/log/nginx && \
    chmod -R 755 /var/lib/nginx

VOLUME ["/etc/letsencrypt"]

EXPOSE 80 443

# Start Nginx and Gunicorn
CMD nginx && gunicorn --bind 0.0.0.0:8000 --workers 3 AUP.wsgi:application
