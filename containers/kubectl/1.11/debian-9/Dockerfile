FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubectl-1.11.7-0-linux-amd64-debian-9.tar.gz && \
    echo "7d1f82718f26e28cf0c76e017a7006cca29dfa011ecdd56e56ca15973b9745c8  /tmp/bitnami/pkg/cache/kubectl-1.11.7-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubectl-1.11.7-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubectl-1.11.7-0-linux-amd64-debian-9.tar.gz

RUN chmod +x /opt/bitnami/kubectl/bin/kubectl
ENV BITNAMI_APP_NAME="kubectl" \
    BITNAMI_IMAGE_VERSION="1.11.7-debian-9-r13" \
    PATH="/opt/bitnami/kubectl/bin:$PATH"

USER 1001
ENTRYPOINT [ "kubectl" ]
CMD [ "--help" ]
