FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/pushgateway-0.9.1-0-linux-amd64-debian-9.tar.gz && \
    echo "ab5b9857a497fb42ac28d74bc44cf8d17a2f04c4b315ecba718df3ac569a031a  /tmp/bitnami/pkg/cache/pushgateway-0.9.1-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/pushgateway-0.9.1-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/pushgateway-0.9.1-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="pushgateway" \
    BITNAMI_IMAGE_VERSION="0.9.1-debian-9-r42" \
    PATH="/opt/bitnami/pushgateway/bin:$PATH"

EXPOSE 9091

WORKDIR /opt/bitnami/pushgateway
USER 1001
ENTRYPOINT [ "/opt/bitnami/pushgateway/bin/pushgateway" ]
