FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libaio1 libc6 libcom-err2 libcurl4 libev4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libunistring2 procps rsync tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/percona-xtrabackup-8.0.26-18-0-linux-amd64-debian-10.tar.gz && \
    echo "07254b5d0de2d04ac51b93d86a6b4239decceb750cd34edf1cfea728c0ef576a  /tmp/bitnami/pkg/cache/percona-xtrabackup-8.0.26-18-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/percona-xtrabackup-8.0.26-18-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/percona-xtrabackup-8.0.26-18-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="percona-xtrabackup" \
    BITNAMI_IMAGE_VERSION="8.0.26-18-debian-10-r112" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mysql/bin:$PATH"

USER 1001
ENTRYPOINT [ "xtrabackup" ]
