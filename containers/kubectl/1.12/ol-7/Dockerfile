FROM bitnami/oraclelinux-extras:7-r195 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kubectl-1.12.3-21-linux-x86_64-ol-7.tar.gz && \
    echo "5bb0059a7f4d7f0438bedc88fd1b3ff1489dc82c38b5be40f83cc4a2c98e6938  /tmp/bitnami/pkg/cache/kubectl-1.12.3-21-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kubectl-1.12.3-21-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kubectl-1.12.3-21-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r195
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/kubectl /opt/bitnami/kubectl
ENV BITNAMI_APP_NAME="kubectl" \
    BITNAMI_IMAGE_VERSION="1.12.3-ol-7-r21" \
    PATH="/opt/bitnami/kubectl/bin:$PATH"

RUN chmod +x /opt/bitnami/kubectl/bin/kubectl

USER 1001
ENTRYPOINT [ "kubectl" ]
CMD [ "--help" ]
