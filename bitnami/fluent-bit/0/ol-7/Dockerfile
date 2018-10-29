FROM bitnami/oraclelinux-extras:7-r152 as buildenv

RUN install_packages bzip2-libs ca-certificates cyrus-sasl-lib elfutils-libelf elfutils-libs glibc keyutils-libs krb5-libs libattr libcap libcom_err libgcc libgcrypt libgpg-error libselinux lz4 nss-softokn-freebl openssl-libs pcre systemd-libs wget xz-libs zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluent-bit-0.14.5-0-linux-x86_64-ol-7.tar.gz && \
    echo "97f0965d4a9a9f03e75a43696336524a5ed2da4ee65e38d1cec396caafc2108b  /tmp/bitnami/pkg/cache/fluent-bit-0.14.5-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluent-bit-0.14.5-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluent-bit-0.14.5-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r152
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/fluent-bit /opt/bitnami/fluent-bit
ENV BITNAMI_APP_NAME="fluent-bit" \
    BITNAMI_IMAGE_VERSION="0.14.5-ol-7-r1" \
    PATH="/opt/bitnami/fluent-bit/bin:$PATH"

EXPOSE 2020

WORKDIR /opt/bitnami/fluent-bit
USER 1001
ENTRYPOINT [ "fluent-bit" ]
CMD [ "-c", "/opt/bitnami/fluent-bit/conf/fluent-bit.conf" ]
