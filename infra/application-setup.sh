cd ~/AUP

if [ "$(docker ps -a -q -f name=web)" ]; then
  echo "Removing existing web container..."
  docker rm -f web
fi


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
  -p 443:443 \
  web
