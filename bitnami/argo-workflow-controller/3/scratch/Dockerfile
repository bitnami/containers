FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/argo-workflow-controller-3.3.8-2-linux-amd64-debian-11.tar.gz && \
    echo "400a382122b4588fdf262256243c2a777324f60c042bdda5a28df49ff5d51aa1  /tmp/bitnami/pkg/cache/argo-workflow-controller-3.3.8-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/argo-workflow-controller-3.3.8-2-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/argo-workflow-controller-3.3.8-2-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/argo-workflow-controller/bin/workflow-controller /workflow-controller

USER 1001

ENTRYPOINT [ "/workflow-controller" ]
