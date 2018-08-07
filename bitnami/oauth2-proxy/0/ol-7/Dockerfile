FROM bitnami/oraclelinux-extras:7-r61 as buildenv

RUN install_packages ca-certificates glibc wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/oauth2-proxy-0.20180625.74543-0-linux-x86_64-ol-7.tar.gz && \
    echo "eb582fedc0776b868591e9444d41488b91ac94a5f05a816d52a53a41a29872b9  /tmp/bitnami/pkg/cache/oauth2-proxy-0.20180625.74543-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/oauth2-proxy-0.20180625.74543-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/oauth2-proxy-0.20180625.74543-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r61
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/oauth2-proxy /opt/bitnami/oauth2-proxy
ENV BITNAMI_APP_NAME="oauth2-proxy" \
    BITNAMI_IMAGE_VERSION="0.20180625.74543-ol-7-r0" \
    PATH="/opt/bitnami/oauth2-proxy/bin:$PATH"

RUN install_packages ca-certificates

EXPOSE 8080 4180

WORKDIR /opt/bitnami/oauth2-proxy
USER 1001
ENTRYPOINT ["oauth2_proxy"]
CMD ["--upstream=http://0.0.0.0:8080/","--http-address=0.0.0.0:4180"]
