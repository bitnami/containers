FROM bitnami/oraclelinux-extras:7-r58 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/metrics-server-0.2.1-0-linux-x86_64-ol-7.tar.gz && \
    echo "da48d5370d9b2be32a97af908207adf5f5376b908580258e85536ac81a6d9d77  /tmp/bitnami/pkg/cache/metrics-server-0.2.1-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/metrics-server-0.2.1-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/metrics-server-0.2.1-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r58
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/metrics-server /opt/bitnami/metrics-server
ENV BITNAMI_APP_NAME="metrics-server" \
    BITNAMI_IMAGE_VERSION="0.2.1-ol-7-r20" \
    PATH="/opt/bitnami/metrics-server/bin:$PATH"

RUN install_packages ca-certificates
RUN chmod -R g+rwX /opt/bitnami/metrics-server

EXPOSE 8443

WORKDIR /opt/bitnami/metrics-server
USER 1001
ENTRYPOINT ["metrics-server","--secure-port=8443"]
