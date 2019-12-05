FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libgcc1 libgcrypt20 libgpg-error0 liblz4-1 liblzma5 libpcre3 libsasl2-2 libselinux1 libssl1.1 libsystemd0 procps unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluent-bit-1.3.3-0-linux-amd64-debian-9.tar.gz && \
    echo "e7d7c5a926a96d804495f91fef614888e4feebc58a0ae0365fb60f6fe9c1016b  /tmp/bitnami/pkg/cache/fluent-bit-1.3.3-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluent-bit-1.3.3-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluent-bit-1.3.3-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="fluent-bit" \
    BITNAMI_IMAGE_VERSION="1.3.3-debian-9-r11" \
    PATH="/opt/bitnami/fluent-bit/bin:$PATH"

EXPOSE 2020

WORKDIR /opt/bitnami/fluent-bit
USER 1001
ENTRYPOINT [ "fluent-bit" ]
CMD [ "-c", "/opt/bitnami/fluent-bit/conf/fluent-bit.conf" ]
