rm -rf ~/AUP

cd ~

git clone https://github.com/GustavoBPereira/AUP.git

cd AUP

# Create certificates directory if it doesn't exist
mkdir -p certs

# Generate self-signed certificate if it doesn't exist
if [ ! -f certs/cert.pem ] || [ ! -f certs/key.pem ]; then
    echo "Generating self-signed SSL certificate..."
    openssl req -x509 -newkey rsa:4096 -nodes -out certs/cert.pem -keyout certs/key.pem -days 365 -subj "/CN=localhost"
fi

docker build --no-cache -t web .

# Check if container exists and remove it if it does
if [ "$(docker ps -a -q -f name=web)" ]; then
  echo "Removing existing web container..."
  docker rm -f web
fi

echo "Environment variables:"
echo "DJANGO_DEBUG: $DJANGO_DEBUG"
echo "DJANGO_SECRET_KEY: $DJANGO_SECRET_KEY"
echo "DB_NAME: $DB_NAME"
echo "DB_USER: $DB_USER"
echo "DB_PASSWORD: $DB_PASSWORD"
echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"

docker run -d \
  --name web \
  -e DJANGO_DEBUG=$DJANGO_DEBUG \
  -e DJANGO_SECRET_KEY="$DJANGO_SECRET_KEY" \
  -e DB_NAME=$DB_NAME \
  -e DB_USER=$DB_USER \
  -e DB_PASSWORD=$DB_PASSWORD \
  -e DB_HOST=$DB_HOST \
  -e DB_PORT=$DB_PORT \
  -v /etc/letsencrypt/live/domain.com:/app/certs:ro \
  -p 443:443 \
  web
