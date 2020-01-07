FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/service-catalog-0.2.2-1-linux-amd64-debian-9.tar.gz && \
    echo "1b9f796e70f5143feec962e837723e2d243cf1ab8af98fb2815bd8c788a03cdc  /tmp/bitnami/pkg/cache/service-catalog-0.2.2-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/service-catalog-0.2.2-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/service-catalog-0.2.2-1-linux-amd64-debian-9.tar.gz
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

ENV BITNAMI_APP_NAME="service-catalog" \
    BITNAMI_IMAGE_VERSION="0.2.2-debian-9-r116" \
    PATH="/opt/bitnami/service-catalog/bin:$PATH"

EXPOSE 8443 443

WORKDIR /opt/bitnami/service-catalog
USER 1001
ENTRYPOINT [ "/opt/bitnami/service-catalog/bin/service-catalog" ]
