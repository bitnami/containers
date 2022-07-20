FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libaio1 libbrotli1 libc6 libcom-err2 libcrypt1 libcurl4 libev4 libffi7 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle8 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libunistring2 procps rsync tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/percona-xtrabackup-2.4.26-151-linux-amd64-debian-11.tar.gz && \
    echo "4d6a19a39fb6771b6d70e35ac82247e50c2c30d39b88f1d9b478ba6a2cc9e945  /tmp/bitnami/pkg/cache/percona-xtrabackup-2.4.26-151-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/percona-xtrabackup-2.4.26-151-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/percona-xtrabackup-2.4.26-151-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="2.4.26" \
    BITNAMI_APP_NAME="percona-xtrabackup" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mysql/bin:$PATH"

USER 1001
ENTRYPOINT [ "xtrabackup" ]
