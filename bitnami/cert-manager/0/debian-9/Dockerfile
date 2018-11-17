FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cert-manager-0.5.2-0-linux-amd64-debian-9.tar.gz && \
    echo "b2b62e756ea549ff9986505530dcd685acee174400bfb8e638cda3fae29f539f  /tmp/bitnami/pkg/cache/cert-manager-0.5.2-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cert-manager-0.5.2-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cert-manager-0.5.2-0-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/cert-manager /opt/bitnami/cert-manager
ENV BITNAMI_APP_NAME="cert-manager" \
    BITNAMI_IMAGE_VERSION="0.5.2-debian-9-r1" \
    PATH="/opt/bitnami/cert-manager/bin:$PATH"

RUN install_packages ca-certificates

WORKDIR /opt/bitnami/cert-manager
USER 1001
ENTRYPOINT [ "/opt/bitnami/cert-manager/bin/cert-manager" ]
