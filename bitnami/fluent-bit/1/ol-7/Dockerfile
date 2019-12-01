FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl cyrus-sasl-lib elfutils-libelf elfutils-libs glibc gzip hostname keyutils-libs krb5-libs libaio-devel libattr libcap libcom_err libgcc libgcrypt libgpg-error libselinux lz4 nss-softokn-freebl openssl-libs pcre procps-ng sudo systemd-libs tar wget which xz-libs zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluent-bit-1.3.3-0-linux-x86_64-ol-7.tar.gz && \
    echo "9b3b94563f5fa400a557e3c123f191d2510e40b431baa8bca561e2f0a7f1d040  /tmp/bitnami/pkg/cache/fluent-bit-1.3.3-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluent-bit-1.3.3-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluent-bit-1.3.3-0-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="fluent-bit" \
    BITNAMI_IMAGE_VERSION="1.3.3-ol-7-r12" \
    PATH="/opt/bitnami/fluent-bit/bin:$PATH"

EXPOSE 2020

WORKDIR /opt/bitnami/fluent-bit
USER 1001
ENTRYPOINT [ "fluent-bit" ]
CMD [ "-c", "/opt/bitnami/fluent-bit/conf/fluent-bit.conf" ]
