FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/airflow/dags" \
    HOME="/" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/common/bin:/opt/bitnami/airflow/venv/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr gnupg gzip libbsd0 libbz2-1.0 libc6 libcom-err2 libedit2 libffi6 libgcc1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncursesw6 libnettle6 libnss-wrapper libp11-kit0 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 locales procps tar zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install python-3.6.10-3 --checksum 9211a0faa0fd4a39ddec622d28d5390b89b3eaef162c3822a3dfb636c14bf7b7
RUN bitnami-pkg install postgresql-client-10.12.0-2 --checksum d410e1b0444e7ca41bc12ef379e435ac4c44263a51eac8f3d455115b5084fd00
RUN bitnami-pkg install tini-0.19.0-0 --checksum 9a8ae20be31a518f042fcec359f2cf35bfdb4e2a56f2fa8ff9ef2ecaf45da80c
RUN bitnami-pkg install gosu-1.12.0-0 --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN bitnami-pkg unpack airflow-worker-1.10.10-0 --checksum ed7c14e2cf7c9af6d5dc5584ebb3974a57375bee7316f2fb9a29fe6eb70ae19e
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

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
    BITNAMI_IMAGE_VERSION="1.10.10-debian-10-r26" \
    C_FORCE_ROOT="True" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:/opt/bitnami/airflow/venv/lib/python3.6/site-packages/numpy/.libs/:$LD_LIBRARY_PATH" \
    LD_PRELOAD="/usr/lib/libnss_wrapper.so" \
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

EXPOSE 8793

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
