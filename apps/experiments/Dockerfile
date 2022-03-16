FROM public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/jupyter:v1.5.0 AS prod

# Structure was taken from: https://github.com/kubeflow/kubeflow/blob/master/components/example-notebook-servers/base/Dockerfile
# Install necessary dependencies to install python packages.
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

COPY --chown=jovyan:users requirements.txt /tmp

# Install python requirements
RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir \
 && rm -f /tmp/requirements.txt \
 && jupyter lab --generate-config \
 && rm -rf ${HOME}/.cache/yarn

# Install Kale extension to jupyterlab
RUN jupyter labextension install kubeflow-kale-labextension
