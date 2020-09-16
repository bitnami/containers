FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/airflow/dags" \
    HOME="/" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/common/bin:/opt/bitnami/airflow/venv/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libbsd0 libbz2-1.0 libc6 libcom-err2 libedit2 libffi6 libgcc1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncursesw6 libnettle6 libp11-kit0 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 procps sudo tar zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install python-3.6.12-1 --checksum dd79db1e55dcb1c32e444576dec92f8888305fe46b7366d43373ab750244c8fd
RUN bitnami-pkg install postgresql-client-10.14.0-0 --checksum 9513f72fbcfc7984ba2c446dd5b9e659f2dd90706bb4d4c2dfd5828cf93403d9
RUN bitnami-pkg install tini-0.19.0-0 --checksum 9a8ae20be31a518f042fcec359f2cf35bfdb4e2a56f2fa8ff9ef2ecaf45da80c
RUN bitnami-pkg install gosu-1.12.0-1 --checksum 51cfb1b7fd7b05b8abd1df0278c698103a9b1a4964bdacd87ca1d5c01631d59c
RUN bitnami-pkg unpack airflow-scheduler-1.10.12-0 --checksum 089aa28c4157b7dfd2cc88a4a51fffbdba6a831ae08d47407a2c6b95e07ad0f2
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

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
    BITNAMI_IMAGE_VERSION="1.10.12-debian-10-r19" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:/opt/bitnami/airflow/venv/lib/python3.6/site-packages/numpy.libs/:$LD_LIBRARY_PATH" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="airflow" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_GROUP="/opt/bitnami/airflow/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/airflow/nss_passwd" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    REDIS_HOST="redis" \
    REDIS_PASSWORD="" \
    REDIS_PORT_NUMBER="6379" \
    REDIS_USER=""

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
