FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/airflow/dags" \
    HOME="/" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/airflow-scheduler/bin:/opt/bitnami/airflow/venv/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl cyrus-sasl-lib glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libedit libffi libgcc libselinux libstdc++ libuuid libxml2 libxslt mariadb-libs ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre procps-ng readline sqlite sudo tar which xz-libs zlib
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install python-3.6.10-0 --checksum 5a8e49832c587612e6b4afa4dfe4708dc2153263ec594006eb7972c3352773b3
RUN bitnami-pkg install postgresql-client-10.11.0-0 --checksum 7698c1aeb96133009652bfe6b05713c2450effcdc53f094194d06fe15a04f580
RUN bitnami-pkg unpack airflow-scheduler-1.10.7-0 --checksum f0c041c14b6678a03f8fa5555bc2a6461835e5df0d973d9253bfbb465d7df2bf
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
RUN rpm -Uvh --nodeps $(repoquery --location nss_wrapper)
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
    AIRFLOW_LOAD_EXAMPLES="yes" \
    AIRFLOW_REDIS_USE_SSL="no" \
    AIRFLOW_WEBSERVER_HOST="airflow" \
    AIRFLOW_WEBSERVER_PORT_NUMBER="8080" \
    BITNAMI_APP_NAME="airflow-scheduler" \
    BITNAMI_IMAGE_VERSION="1.10.7-ol-7-r31" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:/opt/bitnami/airflow/venv/lib/python3.6/site-packages/numpy/.libs/:$LD_LIBRARY_PATH" \
    LD_PRELOAD="/usr/lib64/libnss_wrapper.so" \
    LNAME="airflow" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_GROUP="/opt/bitnami/airflow/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/airflow/nss_passwd" \
    REDIS_HOST="redis" \
    REDIS_PASSWORD="" \
    REDIS_PORT_NUMBER="6379" \
    REDIS_USER=""

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
