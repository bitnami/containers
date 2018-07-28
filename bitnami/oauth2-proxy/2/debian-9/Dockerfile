FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/oauth2-proxy-2.2.0-0-linux-amd64-debian-9.tar.gz && \
    echo "0368fc968c76f264998e11d5ce53b9e0a46a3d9e81e8ef1fece4fd32c4fe14b2  /tmp/bitnami/pkg/cache/oauth2-proxy-2.2.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/oauth2-proxy-2.2.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/oauth2-proxy-2.2.0-0-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/oauth2-proxy /opt/bitnami/oauth2-proxy
ENV BITNAMI_APP_NAME="oauth2-proxy" \
    BITNAMI_IMAGE_VERSION="2.2.0-debian-9-r20" \
    PATH="/opt/bitnami/oauth2-proxy/bin:$PATH"

RUN install_packages ca-certificates

EXPOSE 8080 4180

WORKDIR /opt/bitnami/oauth2-proxy
USER 1001
ENTRYPOINT ["oauth2_proxy"]
CMD ["--upstream=http://0.0.0.0:8080/","--http-address=0.0.0.0:4180"]
