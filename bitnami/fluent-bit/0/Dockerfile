FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates libc6 libgcc1 libgcrypt20 libgpg-error0 liblzma5 libsasl2-2 libssl1.0.0 libsystemd0 wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluent-bit-0.13.4-0-linux-x64-debian-8.tar.gz && \
    echo "3db8cb8f96c0c1694f77d50a1c36566e22cfbdec7c79fe3d234b5c2959f214aa  /tmp/bitnami/pkg/cache/fluent-bit-0.13.4-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluent-bit-0.13.4-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluent-bit-0.13.4-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/fluent-bit /opt/bitnami/fluent-bit
ENV BITNAMI_APP_NAME="fluent-bit" \
    BITNAMI_IMAGE_VERSION="0.13.4-debian-8-r26" \
    PATH="/opt/bitnami/fluent-bit/bin:$PATH"

RUN install_packages ca-certificates libsasl2-2 libssl1.0.0

EXPOSE 2020

WORKDIR /opt/bitnami/fluent-bit
USER 1001
ENTRYPOINT ["fluent-bit"]
CMD ["-c","/opt/bitnami/fluent-bit/conf/fluent-bit.conf"]
