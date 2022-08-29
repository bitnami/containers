FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="8.0.29-22-debian-11-r14" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/percona-xtrabackup" \
      org.opencontainers.image.title="percona-xtrabackup" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="8.0.29-22"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libaio1 libbrotli1 libc6 libcom-err2 libcurl4 libev4 libffi7 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle8 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libunistring2 procps rsync tar zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f percona-xtrabackup-8.0.29-22-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/percona-xtrabackup-8.0.29-22-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "01958406aef1168139baacf7b2ecb59e792ea4b55bef26f9d4305c6adeb7679c  percona-xtrabackup-8.0.29-22-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf percona-xtrabackup-8.0.29-22-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf percona-xtrabackup-8.0.29-22-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="8.0.29-22" \
    BITNAMI_APP_NAME="percona-xtrabackup" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mysql/bin:$PATH"

USER 1001
ENTRYPOINT [ "xtrabackup" ]
