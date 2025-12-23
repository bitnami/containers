# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# This file is included in the final Docker image and SHOULD be overridden when
# deploying the image to prod. Settings configured here are intended for use in local
# development environments. Also note that superset_config_docker.py is imported
# as a final step as a means to override "defaults" configured here
#
import logging
import os

from flask_caching.backends.rediscache import RedisCache

def is_boolean_yes(var):
    if var == 1 or var == "yes" or var == "true":
        return True
    return False

def env(key, default=None):
    return os.getenv(key, default)

logger = logging.getLogger()

## Superset settings
##
SUPERSET_HOME = env("SUPERSET_HOME")

MAPBOX_API_KEY = env('MAPBOX_API_KEY', '')

## Database settings
##
DB_DIALECT = env("SUPERSET_DATABASE_DIALECT", "postgresql+psycopg2")
DB_USER = env("SUPERSET_DATABASE_USER")
DB_PASSWORD = env("SUPERSET_DATABASE_PASSWORD")
DB_HOST = env("SUPERSET_DATABASE_HOST", "postgresql")
DB_PORT = env("SUPERSET_DATABASE_PORT_NUMBER", "5432")
DB_NAME = env("SUPERSET_DATABASE_NAME")
DB_PARAMS = "?sslmode=require" if is_boolean_yes(env("SUPERSET_DATABASE_USE_SSL", "no")) else ""
DB_AUTH = f"{DB_USER}:{DB_PASSWORD}@" if DB_PASSWORD else ""

SQLALCHEMY_DATABASE_URI = f"{DB_DIALECT}://{DB_AUTH}{DB_HOST}:{DB_PORT}/{DB_NAME}{DB_PARAMS}"
SQLALCHEMY_TRACK_MODIFICATIONS = True

## Examples database settings
##
EXAMPLES_DB_DIALECT = env("EXAMPLES_DATABASE_DIALECT", DB_DIALECT)
EXAMPLES_DB_USER = env("EXAMPLES_DATABASE_USER", DB_USER)
EXAMPLES_DB_PASSWORD = env("EXAMPLES_DATABASE_PASSWORD", DB_PASSWORD)
EXAMPLES_DB_HOST = env("EXAMPLES_DATABASE_HOST", DB_HOST)
EXAMPLES_DB_PORT = env("EXAMPLES_DATABASE_PORT_NUMBER", DB_PORT)
EXAMPLES_DB_NAME = env("EXAMPLES_DATABASE_NAME", DB_NAME)
EXAMPLES_DB_PARAMS = "?sslmode=require" if is_boolean_yes(env("EXAMPLES_DATABASE_USE_SSL", env("SUPERSET_DATABASE_USE_SSL", "no"))) else ""
EXAMPLES_DB_AUTH = f"{EXAMPLES_DB_USER}:{EXAMPLES_DB_PASSWORD}@" if EXAMPLES_DB_PASSWORD else ""
SQLALCHEMY_EXAMPLES_URI = f"{EXAMPLES_DB_DIALECT}://{EXAMPLES_DB_AUTH}{EXAMPLES_DB_HOST}:{EXAMPLES_DB_PORT}/{EXAMPLES_DB_NAME}{EXAMPLES_DB_PARAMS}"

## Redis settings
##
REDIS_HOST = env("REDIS_HOST", "redis")
REDIS_PORT = env("REDIS_PORT_NUMBER", "6379")
REDIS_CELERY_DB = env("REDIS_CELERY_DB", "0")
REDIS_DB = env("REDIS_DB", "1")
REDIS_PASSWORD = env("REDIS_PASSWORD")
REDIS_USER = env("REDIS_USER", "")
REDIS_TLS_ENABLED = env("REDIS_TLS_ENABLED", False)
REDIS_SSL_CERT_REQS = env("REDIS_SSL_CERT_REQS")
REDIS_URL_PARAMS = f"ssl_cert_reqs={REDIS_SSL_CERT_REQS}" if REDIS_SSL_CERT_REQS else ""
REDIS_AUTH = f"{REDIS_USER}:{REDIS_PASSWORD}@" if REDIS_PASSWORD else ""
REDIS_BASE_URL = f"redis://{REDIS_AUTH}{REDIS_HOST}:{REDIS_PORT}"
# Redis URLs
REDIS_CELERY_URL = f"{REDIS_BASE_URL}/{REDIS_CELERY_DB}{REDIS_URL_PARAMS}"
REDIS_CACHE_URL = f"{REDIS_BASE_URL}/{REDIS_DB}{REDIS_URL_PARAMS}"

## Cache config
##
CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_DEFAULT_TIMEOUT": 300,
    "CACHE_KEY_PREFIX": "superset_",
    "CACHE_REDIS_URL": REDIS_CACHE_URL,
}
DATA_CACHE_CONFIG = CACHE_CONFIG

## Results backend
##
RESULTS_BACKEND = RedisCache(
    host=REDIS_HOST,
    password=REDIS_PASSWORD,
    port=REDIS_PORT,
    key_prefix='superset_results',
    ssl=REDIS_TLS_ENABLED,
    ssl_cert_reqs=REDIS_SSL_CERT_REQS,
)

## Celery config
##
class CeleryConfig:
    imports  = ("superset.sql_lab", )
    broker_url = REDIS_CELERY_URL
    result_backend = REDIS_CELERY_URL

CELERY_CONFIG = CeleryConfig

## Load user extended config
##
try:
    import superset_config_docker
    from superset_config_docker import *  # noqa

    logger.info(
        f"Loaded your configuration from " f"[{superset_config_docker.__file__}]"
    )
except ImportError:
    logger.info("Using default settings")
