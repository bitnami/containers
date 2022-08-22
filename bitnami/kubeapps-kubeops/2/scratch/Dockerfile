FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubeapps-kubeops-2.5.0-0-linux-amd64-debian-11.tar.gz && \
    echo "a778eadadfee3d782d9f4632c53cdfc1efad412676111adafbc1adc3a2eb89d8  /tmp/bitnami/pkg/cache/kubeapps-kubeops-2.5.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubeapps-kubeops-2.5.0-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubeapps-kubeops-2.5.0-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.5.0-scratch-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kubeapps-kubeops" \
      org.opencontainers.image.title="kubeapps-kubeops" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.5.0"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/kubeapps-kubeops/bin/kubeops /kubeops

USER 1001

CMD [ "/kubeops" ]
