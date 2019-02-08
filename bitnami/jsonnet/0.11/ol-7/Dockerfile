FROM bitnami/oraclelinux-extras:7-r255
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc libgcc libstdc++ wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jsonnet-0.11.2-1-linux-x86_64-ol-7.tar.gz && \
    echo "754b6135e0b86352b39b8005c471f0a51b82315f73f0de00702fe42bd2e28e1a  /tmp/bitnami/pkg/cache/jsonnet-0.11.2-1-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jsonnet-0.11.2-1-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jsonnet-0.11.2-1-linux-x86_64-ol-7.tar.gz

RUN chmod +x /opt/bitnami/jsonnet/bin/jsonnet
ENV BITNAMI_APP_NAME="jsonnet" \
    BITNAMI_IMAGE_VERSION="0.11.2-ol-7-r62" \
    PATH="/opt/bitnami/jsonnet/bin:$PATH"

USER 1001
ENTRYPOINT [ "jsonnet" ]
CMD [ "--help" ]
