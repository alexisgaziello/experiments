#!/bin/bash
set -e

echo -e "\n\nRunning tests."
pipenv run coverage run -m pytest tests "$@"

echo -e "\n\nGenerating report in command line."
pipenv run coverage report

echo -e "\n\nGenerate HTML report."
pipenv run coverage html

echo -e "\n\nAll tests passed successfully."
