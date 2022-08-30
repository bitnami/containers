FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.3.4-debian-11-r1" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/airflow-scheduler" \
      org.opencontainers.image.title="airflow-scheduler" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.3.4"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbsd0 libbz2-1.0 libc6 libcom-err2 libcrypt1 libedit2 libffi7 libgcc-s1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libmd0 libncursesw6 libnettle8 libnsl2 libp11-kit0 libreadline8 libsasl2-2 libsasl2-modules libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libtirpc3 libunistring2 libuuid1 libxml2 libxslt1.1 locales netbase procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-154" --checksum 74a09c2208af7316f32ee3ee8479d70b20ad54f1a989e84b6417e23c1f07c147
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-166" --checksum 9a5fba755f6c8d60eacc80f366f3fbaa57d003913e48c31ba337037bb69e37b3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "10.22.0-1" --checksum 7d2ae29cb7ae2a49ba0a5e192cd31d066e5451802799dcd7163a250ab5cb431f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.3-153" --checksum 4692a063a41c8382fbf1629f92bb91cc3064d50b25bddeb7e1b299c749e39afd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "airflow-scheduler" "2.3.4-0" --checksum fe6af7b1b8651ea46441bb0cd02595be7d3ecf3d792c1fe6e96e222de96bc109
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY rootfs /
RUN /opt/bitnami/scripts/airflow-scheduler/postunpack.sh
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh
ENV AIRFLOW_HOME="/opt/bitnami/airflow" \
    APP_VERSION="2.3.4" \
    BITNAMI_APP_NAME="airflow-scheduler" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:/opt/bitnami/airflow/venv/lib/python3.8/site-packages/numpy.libs/:$LD_LIBRARY_PATH" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="airflow" \
    NSS_WRAPPER_GROUP="/opt/bitnami/airflow/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/airflow/nss_passwd" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/airflow/venv/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/airflow-scheduler/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/airflow-scheduler/run.sh" ]
