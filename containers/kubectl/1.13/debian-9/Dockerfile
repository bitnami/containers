FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubectl-1.13.1-1-linux-amd64-debian-9.tar.gz && \
    echo "17273c67d23dc424628b88eb7401407513ee1a7ecef102b21dc5230195bd5f87  /tmp/bitnami/pkg/cache/kubectl-1.13.1-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubectl-1.13.1-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubectl-1.13.1-1-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/kubectl /opt/bitnami/kubectl
ENV BITNAMI_APP_NAME="kubectl" \
    BITNAMI_IMAGE_VERSION="1.13.1-debian-9-r11" \
    PATH="/opt/bitnami/kubectl/bin:$PATH"

RUN install_packages ca-certificates
RUN chmod +x /opt/bitnami/kubectl/bin/kubectl

USER 1001
ENTRYPOINT [ "kubectl" ]
CMD [ "--help" ]
