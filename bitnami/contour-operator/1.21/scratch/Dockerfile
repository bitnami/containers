FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/contour-operator-1.21.1-1-linux-amd64-debian-11.tar.gz && \
    echo "10804cd2883d0c2da8f75eb5ed84a5b113ebb15fd27492f8be40cdeb9af56ac5  /tmp/bitnami/pkg/cache/contour-operator-1.21.1-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/contour-operator-1.21.1-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/contour-operator-1.21.1-1-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/contour-operator/bin/contour-operator /contour-operator

USER 1001

ENTRYPOINT [ "/contour-operator" ]
