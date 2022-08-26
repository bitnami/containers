FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="8.0.29-22-debian-11-r13" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/percona-xtrabackup" \
      org.opencontainers.image.title="percona-xtrabackup" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="8.0.29-22"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libaio1 libbrotli1 libc6 libcom-err2 libcurl4 libev4 libffi7 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle8 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libunistring2 procps rsync tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/percona-xtrabackup-8.0.29-22-1-linux-amd64-debian-11.tar.gz && \
    echo "cdfab062d8646a33ba421b4095451c09f233c6d0b79f1007bfff2a84f2b59906  /tmp/bitnami/pkg/cache/percona-xtrabackup-8.0.29-22-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/percona-xtrabackup-8.0.29-22-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/percona-xtrabackup-8.0.29-22-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="8.0.29-22" \
    BITNAMI_APP_NAME="percona-xtrabackup" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mysql/bin:$PATH"

USER 1001
ENTRYPOINT [ "xtrabackup" ]
