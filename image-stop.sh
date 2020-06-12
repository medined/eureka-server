#!/bin/bash

CONTAINER_NAME=eureka-01

docker inspect -f '{{.State.Running}}' $CONTAINER_NAME > /dev/null 2>&1

if [ $? == 0 ]; then
    docker stop $CONTAINER_NAME > /dev/null
    docker rm $CONTAINER_NAME > /dev/null
    echo "Eureka stopped."
else
    echo "Eureka not running."
fi
