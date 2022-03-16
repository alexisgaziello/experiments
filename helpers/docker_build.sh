#!/bin/bash
set -e

usage() {
  echo "
Usage: bash $(basename "${0}") [--dev] [-t | --tag <tag>] [ <other-docker-options> ]

Build an image with name and tag plus other args

Arguments description:
  --dev                     Build image with target: 'dev' (default is 'prod').
  -t --tag <tag>            Tag the built image with the given <tag>.
  <other-docker-options>    Other docker options to pass to the docker build command.
"
}

# Config
APP_PATH="$(pwd)"  # We are assuming that we are running the script from the root of the project
APP_NAME="$(basename "$APP_PATH")"  # Name of the app to build
TARGET="prod"  # Target to build the image for
TAG=""  # Tag to use when building the image
export DOCKER_BUILDKIT=1  # Necessary for SSH forwarding config (in dk build, --ssh flag)


# Parse args
while (( "$#" )); do
  case "$1" in
    --dev)
      # Check that the dev build is an option
      if grep -q "AS dev$" ./Dockerfile; then
        TARGET="dev"
      else
        echo "Only prod mode is available for app '$APP_NAME'."
      fi
      shift
      ;;
    -t | --tag)
      # Check that the tag is not empty and that it doesn't start with a '-'
      if [[ -n "$2" ]] && [[ "${2:0:1}" != "-" ]]; then
        # Get the tag
        TAG=$2
        shift 2
      else
        echo "ERROR: Argument for $1 is missing or invalid."
        usage
        exit 1
      fi
      ;;
    *)
      # Other arguments are passed to the docker build command
      break
      ;;
  esac
done

# Set the tag to dev/prod if no tag is passed.
if [[ "$TAG" = "" ]]; then
  if [[ "$TARGET" == "dev" ]]; then
    TAG="dev"
  elif [[ "$TARGET" == "prod" ]]; then
    TAG="prod"
  fi
fi

# Build the image. Note: the tag will be "dev" or "prod" if no tag was passed.
IMAGE="$APP_NAME:$TAG"

echo "INFO: Building '$IMAGE' in '$TARGET' mode..."

docker build \
  --ssh default \
  --tag "$IMAGE" \
  --target "$TARGET" \
  "$@" \
  "$APP_PATH"


