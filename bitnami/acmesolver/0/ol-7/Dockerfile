FROM bitnami/oraclelinux-extras:7-r123 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/acmesolver-0.5.0-1-linux-x86_64-ol-7.tar.gz && \
    echo "c5150abd86fbe5f673f646757a5fe14c8899c830e990895d969d3d4ec6329964  /tmp/bitnami/pkg/cache/acmesolver-0.5.0-1-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/acmesolver-0.5.0-1-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/acmesolver-0.5.0-1-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r123
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/acmesolver /opt/bitnami/acmesolver
ENV BITNAMI_APP_NAME="acmesolver" \
    BITNAMI_IMAGE_VERSION="0.5.0-ol-7-r16" \
    PATH="/opt/bitnami/acmesolver/bin:$PATH"

RUN install_packages ca-certificates

WORKDIR /opt/bitnami/acmesolver
USER 1001
ENTRYPOINT [ "/opt/bitnami/acmesolver/bin/acmesolver" ]
