FROM bitnami/oraclelinux-extras:7-r214 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubectl-1.9.11-1-linux-x86_64-ol-7.tar.gz && \
    echo "35726d8584d3f47ab8f12daa1733d6353fbf54b9b413ee652659580ea2c491c6  /tmp/bitnami/pkg/cache/kubectl-1.9.11-1-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubectl-1.9.11-1-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubectl-1.9.11-1-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r214
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/kubectl /opt/bitnami/kubectl
ENV BITNAMI_APP_NAME="kubectl" \
    BITNAMI_IMAGE_VERSION="1.9.11-ol-7-r14" \
    PATH="/opt/bitnami/kubectl/bin:$PATH"

RUN install_packages ca-certificates
RUN chmod +x /opt/bitnami/kubectl/bin/kubectl

USER 1001
ENTRYPOINT [ "kubectl" ]
CMD [ "--help" ]
