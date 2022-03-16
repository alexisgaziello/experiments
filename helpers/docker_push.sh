#!/bin/bash
set -e

usage() {
  echo "
    Usage: bash $(basename "${0}") <tag>

    Push an image with a name and a tag to the ciderRegistry.
    "
}

# Config
APP_PATH="$(pwd)"  # We are assuming that we are running the script from the root of the project
APP_NAME="$(basename "$APP_PATH")"  # Name of the app to build

# If required <TAG> is missing, echo error message, instructions, and exit
[ -z "$1" ] && echo "Missing required <tag>" && usage && exit 1
TAG=$1

IMAGE="$APP_NAME:$TAG"
echo "INFO: Pushing $IMAGE"
az acr login --name ciderRegistry
docker tag "$IMAGE" ciderregistry.azurecr.io/"$IMAGE"
docker push ciderregistry.azurecr.io/"$IMAGE"
