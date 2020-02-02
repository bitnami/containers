FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip hostname libaio-devel procps-ng sudo tar wget which
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubectl-1.13.4-0-linux-x86_64-ol-7.tar.gz && \
    echo "88a1f58d81e82bd99bc28e06e9922f42015bc882f292398319c51cfc99550c23  /tmp/bitnami/pkg/cache/kubectl-1.13.4-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubectl-1.13.4-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubectl-1.13.4-0-linux-x86_64-ol-7.tar.gz
RUN yum upgrade -y && \
    rm -r /var/cache/yum

RUN chmod +x /opt/bitnami/kubectl/bin/kubectl
ENV BITNAMI_APP_NAME="kubectl" \
    BITNAMI_IMAGE_VERSION="1.13.4-ol-7-r340" \
    PATH="/opt/bitnami/kubectl/bin:$PATH"

USER 1001
ENTRYPOINT [ "kubectl" ]
CMD [ "--help" ]
