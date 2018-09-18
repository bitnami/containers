FROM bitnami/oraclelinux-extras:7-r109 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cert-manager-0.5.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "fb80690363a8b18781ae043552f4eaef7bd63807ef00b0a7d2dd24ba1d171ab9  /tmp/bitnami/pkg/cache/cert-manager-0.5.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cert-manager-0.5.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cert-manager-0.5.0-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r109
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/cert-manager /opt/bitnami/cert-manager
ENV BITNAMI_APP_NAME="cert-manager" \
    BITNAMI_IMAGE_VERSION="0.5.0-ol-7-r1" \
    PATH="/opt/bitnami/cert-manager/bin:$PATH"

RUN install_packages ca-certificates

WORKDIR /opt/bitnami/cert-manager
USER 1001
ENTRYPOINT [ "/opt/bitnami/cert-manager/bin/cert-manager" ]
