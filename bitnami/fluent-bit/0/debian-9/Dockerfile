FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates libc6 libgcc1 libgcrypt20 libgpg-error0 liblz4-1 liblzma5 libpcre3 libsasl2-2 libselinux1 libssl1.1 libsystemd0 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluent-bit-0.13.7-0-linux-amd64-debian-9.tar.gz && \
    echo "a235f877cd26b521e63036d2645b1f7e3801df8df0776a139abe2bdb9fdb87a3  /tmp/bitnami/pkg/cache/fluent-bit-0.13.7-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluent-bit-0.13.7-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluent-bit-0.13.7-0-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/fluent-bit /opt/bitnami/fluent-bit
ENV BITNAMI_APP_NAME="fluent-bit" \
    BITNAMI_IMAGE_VERSION="0.13.7-debian-9-r2" \
    PATH="/opt/bitnami/fluent-bit/bin:$PATH"

RUN install_packages ca-certificates libsasl2-2 libssl1.1

EXPOSE 2020

WORKDIR /opt/bitnami/fluent-bit
USER 1001
ENTRYPOINT ["fluent-bit"]
CMD ["-c","/opt/bitnami/fluent-bit/conf/fluent-bit.conf"]
