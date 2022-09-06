FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="8.0.29-21-debian-11-r8" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/percona-mysql" \
      org.opencontainers.image.title="percona-mysql" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="8.0.29-21"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libaudit1 libbrotli1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcrypt1 libcurl4 libev4 libffi7 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle8 libnghttp2-14 libnuma-dev libp11-kit0 libpam0g libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libudev1 libunistring2 libuuid1 procps tar zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f percona-xtrabackup-binary-8.0.29-22-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/percona-xtrabackup-binary-8.0.29-22-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "9512f78d6fa57a0d7e4e8c8d9ba0821189834e2101271875e2088e1b564b010e  percona-xtrabackup-binary-8.0.29-22-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf percona-xtrabackup-binary-8.0.29-22-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf percona-xtrabackup-binary-8.0.29-22-1-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f ini-file-1.4.3-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/ini-file-1.4.3-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "4692a063a41c8382fbf1629f92bb91cc3064d50b25bddeb7e1b299c749e39afd  ini-file-1.4.3-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf ini-file-1.4.3-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf ini-file-1.4.3-153-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f percona-mysql-8.0.29-21-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/percona-mysql-8.0.29-21-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "5b88dcb9abe9f76954621e06c4234aa8897cb7e3caadb8f2626a0083fcd3d982  percona-mysql-8.0.29-21-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf percona-mysql-8.0.29-21-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf percona-mysql-8.0.29-21-1-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f mysql-shell-8.0.30-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/mysql-shell-8.0.30-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "fa38683773c36e05b36e5bf4b391b4b4f287fc1457512289ead7c07755f29012  mysql-shell-8.0.30-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf mysql-shell-8.0.30-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf mysql-shell-8.0.30-1-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab  gosu-1.14.0-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /opt/bitnami/scripts/mysql/postunpack.sh
ENV APP_VERSION="8.0.29-21" \
    BITNAMI_APP_NAME="percona-mysql" \
    MYSQL_HOME="/opt/bitnami/mysql/conf" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mysql/bin:/opt/bitnami/mysql/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mysql/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mysql/run.sh" ]
