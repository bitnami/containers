FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/pinniped-0.18.0-152-linux-amd64-debian-11.tar.gz && \
    echo "d3b0b2b530b360c067c05122c7e00c9e8bce76844a1f9c64385112a89134c3ec  /tmp/bitnami/pkg/cache/pinniped-0.18.0-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/pinniped-0.18.0-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/pinniped-0.18.0-152-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/pinniped/bin /

ENV PATH="/"

USER 1001

ENTRYPOINT [ "/pinniped-concierge" ]
