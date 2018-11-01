FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/metrics-server-0.3.1-3-linux-amd64-debian-9.tar.gz && \
    echo "622bb9cacd1b73975a927e009ef5086ff8a33358663652a974e84f744dacd626  /tmp/bitnami/pkg/cache/metrics-server-0.3.1-3-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/metrics-server-0.3.1-3-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/metrics-server-0.3.1-3-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/metrics-server /opt/bitnami/metrics-server
ENV BITNAMI_APP_NAME="metrics-server" \
    BITNAMI_IMAGE_VERSION="0.3.1-debian-9-r36" \
    PATH="/opt/bitnami/metrics-server/bin:$PATH"

RUN install_packages ca-certificates
RUN chmod -R g+rwX /opt/bitnami/metrics-server

EXPOSE 8443

WORKDIR /opt/bitnami/metrics-server
USER 1001
ENTRYPOINT [ "metrics-server", "--secure-port=8443" ]
