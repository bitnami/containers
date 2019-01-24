FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/elasticsearch-exporter-1.0.2-0-linux-x86_64-rhel-7.tar.gz && \
    echo "2d6d69ec373e77ca7cf0c04a7d8f6e4126c7eee19f023d12a2f77a259e200278  /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.0.2-0-linux-x86_64-rhel-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.0.2-0-linux-x86_64-rhel-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.0.2-0-linux-x86_64-rhel-7.tar.gz

ENV BITNAMI_APP_NAME="elasticsearch-exporter" \
    BITNAMI_IMAGE_VERSION="1.0.2-rhel-7-r2" \
    BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/elasticsearch-exporter/bin:$PATH"

EXPOSE 9108

WORKDIR /opt/bitnami/elasticsearch-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/elasticsearch-exporter/bin/elasticsearch_exporter" ]
