#!/bin/bash

CONTAINER_NAME=eureka-01
IMAGE=medined/eureka-server:2.3.0.RELEASE

docker inspect -f '{{.State.Running}}' $CONTAINER_NAME > /dev/null 2>/dev/null
if [ $? == 0 ]; then
    echo "Eureka server already running."
else
    docker run \
    --name $CONTAINER_NAME \
    -it \
    --detach \
    --publish 8761:8761 \
    $IMAGE
fi
