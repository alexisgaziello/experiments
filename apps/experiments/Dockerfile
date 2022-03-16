FROM python:3.9-buster as BASE

# Create VENVs inside the project.
ENV PIPENV_VENV_IN_PROJECT=1

WORKDIR /app

RUN pip install pipenv==2022.1.8


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
RUN pipenv run jupyter labextension install kubeflow-kale-labextension


FROM build AS dev
RUN pipenv sync --dev
COPY ./setup.cfg \
    ./run_lints.sh \
    ./run_tests.sh \
    ./
COPY ./tests ./tests


FROM build AS prod
CMD pipenv run jupyter lab
