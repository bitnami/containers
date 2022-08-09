FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wavefront-1.11.0-152-linux-amd64-debian-11.tar.gz && \
    echo "ba9d3388d64d42b73d082e461ce269fe0a1546f2043b9930b3189573d45c2fbb  /tmp/bitnami/pkg/cache/wavefront-1.11.0-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wavefront-1.11.0-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wavefront-1.11.0-152-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY --from=builder /opt/bitnami/wavefront/bin/wavefront-collector /wavefront-collector

USER 1001

ENTRYPOINT [ "/wavefront-collector" ]

CMD [ "--help" ]
