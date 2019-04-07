FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/blackbox-exporter-0.14.0-0-linux-x86_64-rhel-7.tar.gz && \
    echo "112f1831c2295dd798c1027a72383db5d5d28c3f54f5b7ca5da1d3dd7c206785  /tmp/bitnami/pkg/cache/blackbox-exporter-0.14.0-0-linux-x86_64-rhel-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/blackbox-exporter-0.14.0-0-linux-x86_64-rhel-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/blackbox-exporter-0.14.0-0-linux-x86_64-rhel-7.tar.gz

ENV BITNAMI_APP_NAME="blackbox-exporter" \
    BITNAMI_IMAGE_VERSION="0.14.0-rhel-7-r24" \
    BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/blackbox-exporter/bin:$PATH"

EXPOSE 9115

WORKDIR /opt/bitnami/blackbox-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/blackbox-exporter/bin/blackbox_exporter" ]
