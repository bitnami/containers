FROM bitnami/minideb-extras:stretch-r494
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/airflow/dags" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libbsd0 libbz2-1.0 libc6 libcomerr2 libedit2 libffi6 libgcc1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadbclient18 libncurses5 libnettle6 libnss-wrapper libp11-kit0 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg install python-3.6.10-0 --checksum 3d7e860761a828ac03c631386b6711433e07bd96d6184d73c11f59d6a7e3b480
RUN bitnami-pkg install postgresql-client-10.11.0-0 --checksum 134b5a1d358c7684f9f89e3b5ec6d1bd1e814e23e335af88930295e7dd2d2587
RUN bitnami-pkg unpack airflow-scheduler-1.10.7-0 --checksum e8f26845838e863a83f99bf72a389dd3a79af5b943a6859a36d84a3a46c89550

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
    AIRFLOW_LOAD_EXAMPLES="yes" \
    AIRFLOW_REDIS_USE_SSL="no" \
    AIRFLOW_WEBSERVER_HOST="airflow" \
    AIRFLOW_WEBSERVER_PORT_NUMBER="8080" \
    BITNAMI_APP_NAME="airflow-scheduler" \
    BITNAMI_IMAGE_VERSION="1.10.7-debian-9-r7" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:/opt/bitnami/airflow/venv/lib/python3.6/site-packages/numpy/.libs/:$LD_LIBRARY_PATH" \
    LD_PRELOAD="/usr/lib/libnss_wrapper.so" \
    LNAME="airflow" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_GROUP="/opt/bitnami/airflow/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/airflow/nss_passwd" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/airflow-scheduler/bin:/opt/bitnami/airflow/venv/bin:$PATH" \
    REDIS_HOST="redis" \
    REDIS_PASSWORD="" \
    REDIS_PORT_NUMBER="6379" \
    REDIS_USER=""

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
