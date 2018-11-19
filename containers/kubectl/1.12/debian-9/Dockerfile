FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubectl-1.12.2-1-linux-amd64-debian-9.tar.gz && \
    echo "5f5b247bc07e2b504b6a29989346d15ddeb899f9538c00df6e0ae7c9c94e1a86  /tmp/bitnami/pkg/cache/kubectl-1.12.2-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubectl-1.12.2-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubectl-1.12.2-1-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/kubectl /opt/bitnami/kubectl
ENV BITNAMI_APP_NAME="kubectl" \
    BITNAMI_IMAGE_VERSION="1.12.2-debian-9-r11" \
    PATH="/opt/bitnami/kubectl/bin:$PATH"

RUN chmod +x /opt/bitnami/kubectl/bin/kubectl

USER 1001
ENTRYPOINT [ "kubectl" ]
CMD [ "--help" ]
