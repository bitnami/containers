FROM bitnami/oraclelinux-extras:7-r481
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubectl-1.16.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "5df8b2fccd8f63e4a1f477d16c68fdddc917f3dbd964594c3950567334fb0e9b  /tmp/bitnami/pkg/cache/kubectl-1.16.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubectl-1.16.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubectl-1.16.0-0-linux-x86_64-ol-7.tar.gz

RUN chmod +x /opt/bitnami/kubectl/bin/kubectl
ENV BITNAMI_APP_NAME="kubectl" \
    BITNAMI_IMAGE_VERSION="1.16.0-ol-7-r5" \
    PATH="/opt/bitnami/kubectl/bin:$PATH"

USER 1001
ENTRYPOINT [ "kubectl" ]
CMD [ "--help" ]
