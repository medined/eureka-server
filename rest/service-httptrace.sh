#!/bin/bash

EUREKA_HOST="eureka-server"
EUREKA_PORT="8761"
EUREKA_URI="http://$EUREKA_HOST:$EUREKA_PORT"

curl --silent $EUREKA_URI/actuator/httptrace | jq '.'
