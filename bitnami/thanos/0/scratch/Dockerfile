FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/thanos-0.27.0-2-linux-amd64-debian-11.tar.gz && \
    echo "37f49b189c6875242eebd08b0b9a4dd4e1294f834a60d197242445d8ef5c50aa  /tmp/bitnami/pkg/cache/thanos-0.27.0-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/thanos-0.27.0-2-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/thanos-0.27.0-2-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/thanos/bin/thanos /bin/thanos

USER 1001

ENTRYPOINT [ "/bin/thanos" ]
