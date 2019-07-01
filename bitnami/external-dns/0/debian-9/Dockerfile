FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/external-dns-0.5.14-0-linux-amd64-debian-9.tar.gz && \
    echo "c335ecfefd26650dee6e11eb3e6f8b01f599e5efbc5b0c6d9c8b5b2d5c17847d  /tmp/bitnami/pkg/cache/external-dns-0.5.14-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/external-dns-0.5.14-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/external-dns-0.5.14-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="external-dns" \
    BITNAMI_IMAGE_VERSION="0.5.14-debian-9-r49" \
    PATH="/opt/bitnami/external-dns/bin:$PATH"

EXPOSE 7979

WORKDIR /opt/bitnami/external-dns
USER 1001
ENTRYPOINT [ "external-dns" ]
