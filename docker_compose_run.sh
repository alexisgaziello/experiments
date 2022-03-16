#!/bin/bash
set -e


OPTIONAL_DOCKER_COMPOSE_UP_PARAMS=()

# Check if we are running in dev mode
if [[ "$1" == "--dev" ]]; then
  OPTIONAL_DOCKER_COMPOSE_UP_PARAMS+=(-f docker-compose.dev.yaml)
  shift
  echo "Running apps in 'dev' mode."
else
  echo "Running apps in 'prod' mode."
fi


# Check that the --build flag has not been passed in
for arg in "$@"
do
  if [ "$arg" == "--build" ]; then
    echo "--build should not be used with this script. Use helpers/docker_build.sh to build images."
    exit 1
  fi
done


# Select network file (OS specific)
if [[ $OSTYPE == *'darwin'* ]] ; then
  OPTIONAL_DOCKER_COMPOSE_UP_PARAMS+=(-f docker-compose.mac_networking.yaml)
  echo "Using 'mac_networking' mode."
elif [[ $OSTYPE == *'linux'* ]] ; then
  OPTIONAL_DOCKER_COMPOSE_UP_PARAMS+=(-f docker-compose.linux_networking.yaml)
  echo "Using 'linux_networking' mode."
fi


# --no-build flag: we don't support building images through this script because of SSH forwarding.
docker-compose \
  -f docker-compose.yaml \
  "${OPTIONAL_DOCKER_COMPOSE_UP_PARAMS[@]}" \
  --env-file ./apps/mlflow/.env \
  up \
  --no-build \
  "$@"  # Allows you to pass in as many arguments as you like to the original shell script
