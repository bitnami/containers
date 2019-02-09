FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/external-dns-0.5.10-0-linux-x86_64-rhel-7.tar.gz && \
    echo "22bb75017ad7e0a7b5b645ef734a5be111a4aedeb173d0e5e0bbfaccc5e6f701  /tmp/bitnami/pkg/cache/external-dns-0.5.10-0-linux-x86_64-rhel-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/external-dns-0.5.10-0-linux-x86_64-rhel-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/external-dns-0.5.10-0-linux-x86_64-rhel-7.tar.gz

ENV BITNAMI_APP_NAME="external-dns" \
    BITNAMI_IMAGE_VERSION="0.5.10-rhel-7-r8" \
    BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/external-dns/bin:$PATH"

EXPOSE 7979

WORKDIR /opt/bitnami/external-dns
USER 1001
ENTRYPOINT [ "external-dns" ]
