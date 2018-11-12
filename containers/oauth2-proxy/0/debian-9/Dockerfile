FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates libc6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/oauth2-proxy-0.20180625.74543-4-linux-amd64-debian-9.tar.gz && \
    echo "99476f2ac4d32c58273323712f4c26e44ec1d3c27e34ef3ac7f52e87f2f5e5bc  /tmp/bitnami/pkg/cache/oauth2-proxy-0.20180625.74543-4-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/oauth2-proxy-0.20180625.74543-4-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/oauth2-proxy-0.20180625.74543-4-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/oauth2-proxy /opt/bitnami/oauth2-proxy
ENV BITNAMI_APP_NAME="oauth2-proxy" \
    BITNAMI_IMAGE_VERSION="0.20180625.74543-debian-9-r77" \
    PATH="/opt/bitnami/oauth2-proxy/bin:$PATH"

RUN install_packages ca-certificates

EXPOSE 8080 4180

WORKDIR /opt/bitnami/oauth2-proxy
USER 1001
ENTRYPOINT [ "oauth2_proxy" ]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
