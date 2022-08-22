FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/sealed-secrets-0.18.1-2-linux-amd64-debian-11.tar.gz && \
    echo "d58bbb38cf5a54f69a93cbe043fc0fec34df3a873c646768c40b77b55cdf338c  /tmp/bitnami/pkg/cache/sealed-secrets-0.18.1-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/sealed-secrets-0.18.1-2-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/sealed-secrets-0.18.1-2-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/sealed-secrets/bin/controller /controller
COPY --from=builder /opt/bitnami/sealed-secrets/bin/kubeseal /kubeseal

USER 1001

ENTRYPOINT [ "/controller" ]
