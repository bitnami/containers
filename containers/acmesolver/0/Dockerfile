FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/acmesolver-0.3.0-0-linux-x64-debian-8.tar.gz && \
    echo "fd3bd6e464f50ad7bc1268121c707351728b2431e1e46aaf88ef9e0a5d0cc7a5  /tmp/bitnami/pkg/cache/acmesolver-0.3.0-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/acmesolver-0.3.0-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/acmesolver-0.3.0-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/acmesolver /opt/bitnami/acmesolver
ENV BITNAMI_APP_NAME="acmesolver" \
    BITNAMI_IMAGE_VERSION="0.3.0-r25" \
    PATH="/opt/bitnami/acmesolver/bin:$PATH"

RUN install_packages ca-certificates

WORKDIR /opt/bitnami/acmesolver
USER 1001
ENTRYPOINT ["/opt/bitnami/acmesolver/bin/acmesolver"]
