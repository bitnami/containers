FROM bitnami/oraclelinux-extras:7-r532
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/airflow/dags" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libedit libffi libgcc libselinux libstdc++ libuuid libxml2 libxslt mariadb-libs ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre readline sqlite xz-libs zlib
RUN bitnami-pkg install python-3.6.9-2 --checksum 66cd0029243b797825cf74faab4bf6030ecac6152b67646881259da1a1c321c0
RUN bitnami-pkg install postgresql-client-10.11.0-0 --checksum 7698c1aeb96133009652bfe6b05713c2450effcdc53f094194d06fe15a04f580
RUN bitnami-pkg unpack airflow-1.10.6-0 --checksum 79f9945a5664e9d6b521f3af605ed35b9dec3c23b7adcee7d4a765a9397d9094

COPY rootfs /
RUN rpm -Uvh --nodeps $(repoquery --location nss_wrapper)
ENV AIRFLOW_BASE_URL="" \
    AIRFLOW_DATABASE_HOST="postgresql" \
    AIRFLOW_DATABASE_NAME="bitnami_airflow" \
    AIRFLOW_DATABASE_PASSWORD="bitnami1" \
    AIRFLOW_DATABASE_PORT_NUMBER="5432" \
    AIRFLOW_DATABASE_USERNAME="bn_airflow" \
    AIRFLOW_DATABASE_USE_SSL="no" \
    AIRFLOW_EMAIL="user@example.com" \
    AIRFLOW_EXECUTOR="SequentialExecutor" \
    AIRFLOW_FERNET_KEY="" \
    AIRFLOW_FIRSTNAME="Firstname" \
    AIRFLOW_HOME="/opt/bitnami/airflow" \
    AIRFLOW_HOSTNAME_CALLABLE="" \
    AIRFLOW_LASTNAME="Lastname" \
    AIRFLOW_LOAD_EXAMPLES="yes" \
    AIRFLOW_PASSWORD="bitnami" \
    AIRFLOW_REDIS_USE_SSL="no" \
    AIRFLOW_USERNAME="user" \
    AIRFLOW_WEBSERVER_HOST="127.0.0.1" \
    AIRFLOW_WEBSERVER_PORT_NUMBER="8080" \
    BITNAMI_APP_NAME="airflow" \
    BITNAMI_IMAGE_VERSION="1.10.6-ol-7-r3" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:/opt/bitnami/airflow/venv/lib/python3.6/site-packages/numpy/.libs/:$LD_LIBRARY_PATH" \
    LD_PRELOAD="/usr/lib64/libnss_wrapper.so" \
    LNAME="airflow" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_GROUP="/opt/bitnami/airflow/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/airflow/nss_passwd" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/airflow/bin:/opt/bitnami/airflow/venv/bin:$PATH" \
    REDIS_HOST="redis" \
    REDIS_PASSWORD="" \
    REDIS_PORT_NUMBER="6379" \
    REDIS_USER=""

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
