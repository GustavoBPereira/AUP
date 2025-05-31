cd ~/AUP

if [ "$(docker ps -a -q -f name=web)" ]; then
  echo "Removing existing web container..."
  docker rm -f web
fi

# Ensure certificates are readable
sudo chmod -R 755 /etc/letsencrypt/live
sudo chmod -R 755 /etc/letsencrypt/archive

# Print certificate information
echo "Certificate information:"
sudo ls -la /etc/letsencrypt/live/aup.rec.br/

docker build --no-cache -t web .

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
  -v /etc/letsencrypt/live:/etc/letsencrypt/live:ro \
  -v /etc/letsencrypt/archive:/etc/letsencrypt/archive:ro \
  -p 80:80 \
  -p 443:443 \
  web
