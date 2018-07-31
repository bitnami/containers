FROM bitnami/oraclelinux-extras:7-r53 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/oauth2-proxy-2.2.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "9a55c32b003a66449e3629c85b9c2c2f0a0f8c2ec9c8f1a6d05c19bca8021dd7  /tmp/bitnami/pkg/cache/oauth2-proxy-2.2.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/oauth2-proxy-2.2.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/oauth2-proxy-2.2.0-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r53
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/oauth2-proxy /opt/bitnami/oauth2-proxy
ENV BITNAMI_APP_NAME="oauth2-proxy" \
    BITNAMI_IMAGE_VERSION="2.2.0-ol-7-r36" \
    PATH="/opt/bitnami/oauth2-proxy/bin:$PATH"

RUN install_packages ca-certificates

EXPOSE 8080 4180

WORKDIR /opt/bitnami/oauth2-proxy
USER 1001
ENTRYPOINT ["oauth2_proxy"]
CMD ["--upstream=http://0.0.0.0:8080/","--http-address=0.0.0.0:4180"]
