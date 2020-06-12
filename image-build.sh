#!/bin/bash

IMAGE=medined/eureka-server:2.3.0.RELEASE

if [ ! -f gradlew ]; then
  echo "Missing gradlew"
else
    ./gradlew bootJar
    cp ./build/libs/eureka-server-2.3.0.RELEASE.jar docker/app.jar
    pushd docker > /dev/null
    docker build -t $IMAGE .
    popd > /dev/null
fi
