FROM bitnami/oraclelinux-extras:7-r417
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubectl-1.15.1-0-linux-x86_64-ol-7.tar.gz && \
    echo "5b744cb302ab155e14a1d413f15e8522febef9705922b5954ff0b38cd7b1e51d  /tmp/bitnami/pkg/cache/kubectl-1.15.1-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubectl-1.15.1-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubectl-1.15.1-0-linux-x86_64-ol-7.tar.gz

RUN chmod +x /opt/bitnami/kubectl/bin/kubectl
ENV BITNAMI_APP_NAME="kubectl" \
    BITNAMI_IMAGE_VERSION="1.15.1-ol-7-r17" \
    PATH="/opt/bitnami/kubectl/bin:$PATH"

USER 1001
ENTRYPOINT [ "kubectl" ]
CMD [ "--help" ]
