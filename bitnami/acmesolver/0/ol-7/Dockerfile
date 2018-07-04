FROM bitnami/oraclelinux-extras:7-r25 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/acmesolver-0.3.1-0-linux-x86_64-ol-7.tar.gz && \
    echo "06b1279d7834c2666c5ea884725679fe8e39070a54425dd76a9e8fbf946920fa  /tmp/bitnami/pkg/cache/acmesolver-0.3.1-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/acmesolver-0.3.1-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/acmesolver-0.3.1-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r25
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/acmesolver /opt/bitnami/acmesolver
ENV BITNAMI_APP_NAME="acmesolver" \
    BITNAMI_IMAGE_VERSION="0.3.1-ol-7-r8" \
    PATH="/opt/bitnami/acmesolver/bin:$PATH"

RUN install_packages ca-certificates

WORKDIR /opt/bitnami/acmesolver
USER 1001
ENTRYPOINT ["/opt/bitnami/acmesolver/bin/acmesolver"]
