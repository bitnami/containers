FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubeapps-assetsvc-2.4.5-150-linux-amd64-debian-11.tar.gz && \
    echo "39e4c9bf2dd2d68dbbd3d3632535bf76bd54457b0709030b669cc39d74afc0af  /tmp/bitnami/pkg/cache/kubeapps-assetsvc-2.4.5-150-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubeapps-assetsvc-2.4.5-150-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubeapps-assetsvc-2.4.5-150-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY --from=builder /opt/bitnami/kubeapps-assetsvc/bin/assetsvc /assetsvc

EXPOSE 8080

USER 1001

CMD [ "/assetsvc" ]
