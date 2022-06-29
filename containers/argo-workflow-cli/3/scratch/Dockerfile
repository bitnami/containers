FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/argo-workflows-3.3.8-0-linux-amd64-debian-11.tar.gz && \
    echo "a85bf6fe4db821f176c69ff72d4783913ae3c176cafcbc38f98012ea0e35a3c9  /tmp/bitnami/pkg/cache/argo-workflows-3.3.8-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/argo-workflows-3.3.8-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/argo-workflows-3.3.8-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/argo-workflows/hack/nsswitch.conf  /etc/nsswitch.conf
COPY --from=builder /opt/bitnami/argo-workflows/bin/argo /argo
COPY --from=builder /opt/bitnami/argo-workflows/hack/ssh_known_hosts /etc/ssh/ssh_known_hosts

USER 1001

ENTRYPOINT [ "/argo" ]
