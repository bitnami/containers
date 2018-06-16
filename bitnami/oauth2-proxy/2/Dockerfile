FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/oauth2-proxy-2.2.0-0-linux-x64-debian-8.tar.gz && \
    echo "7be090b4b9a6a4c36fbb5a16de46f7cf5331fa669dbf221b95f956c9d6793a7c  /tmp/bitnami/pkg/cache/oauth2-proxy-2.2.0-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/oauth2-proxy-2.2.0-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/oauth2-proxy-2.2.0-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/oauth2-proxy /opt/bitnami/oauth2-proxy
ENV BITNAMI_APP_NAME="oauth2-proxy" \
    BITNAMI_IMAGE_VERSION="2.2.0-r18" \
    PATH="/opt/bitnami/oauth2-proxy/bin:$PATH"

RUN install_packages ca-certificates

EXPOSE 8080 4180

WORKDIR /opt/bitnami/oauth2-proxy
USER 1001
ENTRYPOINT ["oauth2_proxy"]
CMD ["--upstream=http://0.0.0.0:8080/","--http-address=0.0.0.0:4180"]
