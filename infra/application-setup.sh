rm -rf ~/AUP

cd ~

git clone https://github.com/GustavoBPereira/AUP.git

cd AUP

docker build --no-cache -t web .

# Check if container exists and remove it if it does
if [ "$(docker ps -a -q -f name=web)" ]; then
  echo "Removing existing web container..."
  docker rm -f web
fi

docker run -d \
  --name web \
  -e DJANGO_DEBUG=$DJANGO_DEBUG \
  -e DJANGO_SECRET_KEY="$DJANGO_SECRET_KEY" \
  -e DB_NAME=$DB_NAME \
  -e DB_USER=$DB_USER \
  -e DB_PASSWORD=$DB_PASSWORD \
  -e DB_HOST=$DB_HOST \
  -e DB_PORT=$DB_PORT \
  -p 80:80 \
  web
