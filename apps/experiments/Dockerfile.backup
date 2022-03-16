FROM node:16.14-buster AS node
# This stage is used to get the node.js binaries


FROM python:3.9-buster AS base

# Copy over the node.js binaries. Required for Kale.
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

# Create VENVs inside the project.
ENV PIPENV_VENV_IN_PROJECT=1

WORKDIR /app

# Install pipenv and npm
RUN pip install pipenv==2022.1.8
RUN npm install -g npm@8.5


FROM base AS make-lockfile
COPY ./Pipfile ./
RUN pipenv install --dev


FROM base AS build
COPY version.txt \
    ./Pipfile \
    ./Pipfile.lock \
    ./
COPY src ./src
RUN pipenv sync

# Install Kale dependency
RUN pipenv run jupyter labextension install kubeflow-kale-labextension


FROM build AS dev
RUN pipenv sync --dev
COPY ./setup.cfg \
    ./run_lints.sh \
    ./run_tests.sh \
    ./
COPY ./tests ./tests

CMD pipenv run jupyter lab --allow-root --ip=0.0.0.0


FROM python:3.9-slim-buster AS prod

COPY --from=build /app /app
WORKDIR /app

CMD . .venv/bin/activate && python -m jupyter lab --allow-root --ip=0.0.0.0
