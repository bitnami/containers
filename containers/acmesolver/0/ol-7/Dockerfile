FROM bitnami/oraclelinux-extras:7-r197 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/acmesolver-0.5.2-20-linux-x86_64-ol-7.tar.gz && \
    echo "75f479a5949a45a49b3cd82ea65c2967f9c8c965a7767797d596e94a9c7e6db0  /tmp/bitnami/pkg/cache/acmesolver-0.5.2-20-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/acmesolver-0.5.2-20-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/acmesolver-0.5.2-20-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r197
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/acmesolver /opt/bitnami/acmesolver
ENV BITNAMI_APP_NAME="acmesolver" \
    BITNAMI_IMAGE_VERSION="0.5.2-ol-7-r31" \
    PATH="/opt/bitnami/acmesolver/bin:$PATH"

RUN install_packages ca-certificates

WORKDIR /opt/bitnami/acmesolver
USER 1001
ENTRYPOINT [ "/opt/bitnami/acmesolver/bin/acmesolver" ]
