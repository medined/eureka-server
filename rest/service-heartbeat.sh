#!/bin/bash

EUREKA_HOST="localhost"
EUREKA_PORT="8761"
EUREKA_URI="http://$EUREKA_HOST:$EUREKA_PORT"

SERVICE_NAME="FAKE-SERVICE"
HOST_NAME="${1:-fake01}"

while [ 1 ]
do
  curl -X PUT $EUREKA_URI/eureka/apps/$SERVICE_NAME/$HOST_NAME
  echo "Sleeping..."
  sleep 30
done
