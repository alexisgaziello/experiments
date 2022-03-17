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
RUN pipenv sync
COPY src ./src

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

# Common environemnt variables
# Structure was taken from: https://github.com/kubeflow/kubeflow/blob/master/components/example-notebook-servers/base/Dockerfile

ENV NB_USER jovyan
ENV NB_UID 1000
ENV NB_PREFIX /
ENV HOME /home/$NB_USER
ENV SHELL /bin/bash

WORKDIR $HOME
USER $NB_USER

# Set shell to bash
SHELL ["/bin/bash", "-c"]

COPY --from=build /home/jovyan /home/jovyan

EXPOSE 8888

CMD . .venv/bin/activate \
 && python -m jupyter lab \
 --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser \
 --allow-root --port=8888 --LabApp.token='' --LabApp.password='' \
 --LabApp.allow_origin='*' --LabApp.base_url=${NB_PREFIX}"
