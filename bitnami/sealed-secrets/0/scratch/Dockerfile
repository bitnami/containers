FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/sealed-secrets-0.18.0-150-linux-amd64-debian-11.tar.gz && \
    echo "8a3fea19d67a4acce5fc97ab2976ffd9c042417c13f84a60cfd7490355880fd5  /tmp/bitnami/pkg/cache/sealed-secrets-0.18.0-150-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/sealed-secrets-0.18.0-150-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/sealed-secrets-0.18.0-150-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/sealed-secrets/bin/controller /controller
COPY --from=builder /opt/bitnami/sealed-secrets/bin/kubeseal /kubeseal

USER 1001

ENTRYPOINT [ "/controller" ]
