FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubectl-1.13.3-0-linux-amd64-debian-9.tar.gz && \
    echo "572a6e6d3d5ecd0dc816d26a46e468a511578e7ff3388e90b1337dd9653616d3  /tmp/bitnami/pkg/cache/kubectl-1.13.3-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubectl-1.13.3-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubectl-1.13.3-0-linux-amd64-debian-9.tar.gz

RUN chmod +x /opt/bitnami/kubectl/bin/kubectl
ENV BITNAMI_APP_NAME="kubectl" \
    BITNAMI_IMAGE_VERSION="1.13.3-debian-9-r6" \
    PATH="/opt/bitnami/kubectl/bin:$PATH"

USER 1001
ENTRYPOINT [ "kubectl" ]
CMD [ "--help" ]
