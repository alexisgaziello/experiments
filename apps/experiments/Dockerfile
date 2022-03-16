FROM public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/jupyter:v1.5.0 AS prod

# Structure was taken from: https://github.com/kubeflow/kubeflow/blob/master/components/example-notebook-servers/base/Dockerfile
USER root
RUN apt-get -yq update \
  && apt-get -yq install --no-install-recommends \
    libpq-dev \
    gcc \
    libc6-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*


# Structure was taken from: https://github.com/kubeflow/kubeflow/blob/master/components/example-notebook-servers/jupyter/Dockerfile
USER ${NB_UID}

COPY requirements.txt /tmp

RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir \
 && rm -f /tmp/requirements.txt \
 && jupyter lab --generate-config \
 && rm -rf ${HOME}/.cache/yarn


# Install Kale dependency
RUN jupyter labextension install kubeflow-kale-labextension
