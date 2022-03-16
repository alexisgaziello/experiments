#!/bin/bash
set -e

ENFORCED_FILES=(
  "src"
  "tests"
)

echo "Running pylint..."
pipenv run pylint --rcfile=setup.cfg "${ENFORCED_FILES[@]}"

echo -e "\n\nRunning flake8..."
pipenv run flake8 "${ENFORCED_FILES[@]}"

echo -e "\n\nRunning mypy..."
pipenv run mypy "${ENFORCED_FILES[@]}"

echo -e "\n\nAll lints passed successfully."
