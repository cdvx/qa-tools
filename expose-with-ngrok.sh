#!/bin/bash

DOCKER_COMPOSE_FILE="docker-compose.yaml"
LOCAL_PORT=8080


echo "Starting the Docker Compose application..."
docker-compose -f $DOCKER_COMPOSE_FILE up -d

# wait for app to start
sleep 30


echo "Starting ngrok to expose http://127.0.0.1:${LOCAL_PORT}..."
ngrok http ${LOCAL_PORT} > /dev/null &


NGROK_PID=$!

# wait for ngrok to initialization
sleep 5


NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')

# ngrok URL
echo "application is available at: $NGROK_URL"

# when user terminates app, clean up
read -p "Press ENTER to stop ngrok and shut down Docker Compose..."


kill $NGROK_PID

# clean up
docker-compose -f $DOCKER_COMPOSE_FILE down

echo "application stopped."