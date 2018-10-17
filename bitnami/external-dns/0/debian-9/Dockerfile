FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/external-dns-0.5.8-1-linux-amd64-debian-9.tar.gz && \
    echo "e6229ebe923110bf17f754a4c86d8bb8381d7fdaaa0cec19616faa32c6fcbe22  /tmp/bitnami/pkg/cache/external-dns-0.5.8-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/external-dns-0.5.8-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/external-dns-0.5.8-1-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/external-dns /opt/bitnami/external-dns
ENV BITNAMI_APP_NAME="external-dns" \
    BITNAMI_IMAGE_VERSION="0.5.8-debian-9-r1" \
    PATH="/opt/bitnami/external-dns/bin:$PATH"

RUN install_packages ca-certificates

EXPOSE 7979

WORKDIR /opt/bitnami/external-dns
USER 1001
ENTRYPOINT [ "external-dns" ]
