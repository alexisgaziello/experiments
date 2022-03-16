#!/bin/bash
set -e

usage() {
  echo "
Usage: bash $(basename "${0}") [--dev] [ <other-docker-options> ]

Build an image with name and tag plus other args

Arguments description:
  --dev                   Build image with target: 'dev' (default is 'prod').
  <other-docker-options>  Other docker options to pass to the docker build command.
"
}

# Arguments config
APPS_PATH="$(pwd)/apps/*"

# Build the image(s)
for APP_PATH in $APPS_PATH
do
  if [[ -d "$APP_PATH" ]]; then  # If it's a directory.

    cd "$APP_PATH"
    if [[ -f ./Dockerfile ]]; then  # If a Dockerfile is found.
      bash helpers/docker_build.sh "$@"
    else
      echo "Skipping $APP_PATH. No Dockerfile was found."
    fi
  fi
done
