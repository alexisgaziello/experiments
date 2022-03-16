#!/bin/bash
set -e


# Usage: bash make_lockfile.sh
#
# Build a simple image, generate the lockfile and extract it.


# Config
APP_PATH="$(pwd)"  # We are assuming that we are running the script from the root of the project
APP_NAME="$(basename "$APP_PATH")"  # Name of the app to build
export DOCKER_BUILDKIT=1  # Necessary for SSH forwarding config (in dk build, --ssh flag)
LOCKFILE_TAG="make-lockfile"

# The following line matches a file named 'Pipfile.lock' or 'package-lock.json'. This way we can avoid defining it.
LOCKFILE_NAME=$(find -E . -maxdepth 1 -type f -regex './Pipfile\.lock|./package-lock\.json')
# If there are no matches, exit
if [[ "$LOCKFILE_NAME" == "" ]]; then
  echo "
ERROR: No lockfile found in '$APP_PATH'.
  The script needs to find a lockfile to get the name of the lockfile to extract from the docker image.
  If a new microservice is being setup and it's the first build, just run 'touch <lockfile name>' to create an empty lockfile and define it's name.
  Supported lockfile names:
   - Pipfile.lock
   - package-lock.json
 "
  exit 1
fi
# If there is more than 1 match, exit
FILES_MATCHED=$(wc -l <<< "$LOCKFILE_NAME")
if [[ $FILES_MATCHED -gt 1 ]]; then
  echo "ERROR: Multiple lockfiles found in $APP_PATH."
  echo "Files found:"
  echo "$LOCKFILE_NAME"
  exit 1
fi
# Successfully found a lockfile. Let's get the name
LOCKFILE_NAME=$(basename "$LOCKFILE_NAME")

echo "INFO: Making lockfile image for: $APP_NAME"
docker build \
  --ssh default \
  --no-cache \
  --tag "$APP_NAME":"$LOCKFILE_TAG" \
  --target "$LOCKFILE_TAG" \
  "$APP_PATH"

echo "INFO: Getting $LOCKFILE_NAME from image..."
docker run --rm "$APP_NAME:$LOCKFILE_TAG" cat "$LOCKFILE_NAME" > "$LOCKFILE_NAME"
