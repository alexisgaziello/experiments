"""
config.py
"""

import os
from typing import Any

from mlflow import set_tracking_uri, set_experiment, start_run
from sqlalchemy import create_engine


# POSTGRES
DATA_LAKE_IP = os.environ["POSTGRESQL_IP"]
DATA_LAKE_PORT = os.environ["POSTGRESQL_PORT"]
DATA_LAKE_PASSWORD = os.environ["POSTGRESQL_PASSWORD"]
DATA_LAKE_DATABASE = os.environ["POSTGRESQL_DATABASE"]

# The username is hardcoded because we want a read-only user
DATA_LAKE_USERNAME = "oc_bigdata"

DATA_LAKE_BASE_URL = f"postgresql://{DATA_LAKE_USERNAME}:{DATA_LAKE_PASSWORD}@{DATA_LAKE_IP}:{DATA_LAKE_PORT}"
DATA_LAKE_ENGINE = create_engine(f"{DATA_LAKE_BASE_URL}/{DATA_LAKE_DATABASE}", client_encoding='utf8')


def configure_mlflow_experiment(experiment_name: str, version: str):
    set_tracking_uri(f"http://{MLFLOW_IP}:{MLFLOW_PORT}")
    set_experiment(experiment_name)
    start_run(run_name=version)


def save_model(mlflow_model: Any, model, model_name: str):
    mlflow_model.log_model(model, model_name)
