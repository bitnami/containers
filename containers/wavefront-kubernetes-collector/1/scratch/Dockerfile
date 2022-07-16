FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wavefront-1.11.0-151-linux-amd64-debian-11.tar.gz && \
    echo "95aaa5c341af8da0e0d83bea5a6bb2e4821cb74f8926267b64321eeaacbbba17  /tmp/bitnami/pkg/cache/wavefront-1.11.0-151-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wavefront-1.11.0-151-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wavefront-1.11.0-151-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY --from=builder /opt/bitnami/wavefront/bin/wavefront-collector /wavefront-collector

USER 1001

ENTRYPOINT [ "/wavefront-collector" ]

CMD [ "--help" ]
