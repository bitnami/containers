FROM bitnami/oraclelinux-extras:7-r49 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cert-manager-0.4.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "f38245fe9fc9f6e1c08f3b41dad9e725614f4a780a6f2c98d1c1c14f367898bd  /tmp/bitnami/pkg/cache/cert-manager-0.4.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cert-manager-0.4.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cert-manager-0.4.0-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r49
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/cert-manager /opt/bitnami/cert-manager
ENV BITNAMI_APP_NAME="cert-manager" \
    BITNAMI_IMAGE_VERSION="0.4.0-ol-7-r2" \
    PATH="/opt/bitnami/cert-manager/bin:$PATH"

RUN install_packages ca-certificates

WORKDIR /opt/bitnami/cert-manager
USER 1001
ENTRYPOINT ["/opt/bitnami/cert-manager/bin/cert-manager"]
