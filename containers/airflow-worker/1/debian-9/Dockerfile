FROM bitnami/minideb-extras:stretch-r402
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/airflow/dags" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libbsd0 libbz2-1.0 libc6 libcomerr2 libedit2 libffi6 libgcc1 libgssapi-krb5-2 libicu57 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libmariadbclient18 libncurses5 libnss-wrapper libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtinfo5 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg install python-3.6.8-2 --checksum 2eb057ee7701667327f6bcc1fc8765abe5d9d003a64124e5f8505fa692e71eb8
RUN bitnami-pkg install postgresql-client-10.9.0-0 --checksum 1a1b4b3f6582abf88a6d109c0f55a65496f0a23b5fadc0b8642800d4d29179e0
RUN bitnami-pkg unpack airflow-worker-1.10.3-2 --checksum 03754116b8cac38298bc8b452719afee26fe0616743a87d77b9b819f303dc8a1

COPY rootfs /
ENV AIRFLOW_DATABASE_HOST="postgresql" \
    AIRFLOW_DATABASE_NAME="bitnami_airflow" \
    AIRFLOW_DATABASE_PASSWORD="bitnami1" \
    AIRFLOW_DATABASE_PORT_NUMBER="5432" \
    AIRFLOW_DATABASE_USERNAME="bn_airflow" \
    AIRFLOW_DATABASE_USE_SSL="no" \
    AIRFLOW_EXECUTOR="SequentialExecutor" \
    AIRFLOW_FERNET_KEY="" \
    AIRFLOW_HOME="/opt/bitnami/airflow" \
    AIRFLOW_HOSTNAME_CALLABLE="" \
    AIRFLOW_REDIS_USE_SSL="no" \
    AIRFLOW_WEBSERVER_HOST="airflow" \
    AIRFLOW_WEBSERVER_PORT_NUMBER="8080" \
    AIRFLOW_WORKER_PORT_NUMBER="8793" \
    BITNAMI_APP_NAME="airflow-worker" \
    BITNAMI_IMAGE_VERSION="1.10.3-debian-9-r55" \
    C_FORCE_ROOT="True" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:/opt/bitnami/airflow/venv/lib/python3.6/site-packages/numpy/.libs/:$LD_LIBRARY_PATH" \
    LD_PRELOAD="/usr/lib/libnss_wrapper.so" \
    LNAME="airflow" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_GROUP="/opt/bitnami/airflow/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/airflow/nss_passwd" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/airflow-worker/bin:/opt/bitnami/airflow/venv/bin:$PATH" \
    REDIS_HOST="redis" \
    REDIS_PASSWORD="" \
    REDIS_PORT_NUMBER="6379" \
    REDIS_USER=""

EXPOSE 8793

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
