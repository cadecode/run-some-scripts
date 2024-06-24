#!/bin/bash
# This is a shell script to get docker container status which is reported by docker health-check
CONTAINER_NAME=$1

cmd="docker inspect --format {{.State.Health.Status}} ${CONTAINER_NAME}"
status=$(${cmd})
result=$?
if [[ ${result} == 0 && ${status} == 'healthy' ]]; then :
  exit 0
else
  exit 1
fi
