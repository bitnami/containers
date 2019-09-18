FROM bitnami/oraclelinux-extras:7-r470
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/oauth2-proxy-4.0.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "62d9a4222e674c4a8f1eb8fc8597751ee1140c938998809fcbd715ca41bad578  /tmp/bitnami/pkg/cache/oauth2-proxy-4.0.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/oauth2-proxy-4.0.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/oauth2-proxy-4.0.0-0-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="oauth2-proxy" \
    BITNAMI_IMAGE_VERSION="4.0.0-ol-7-r22" \
    PATH="/opt/bitnami/oauth2-proxy/bin:$PATH"

EXPOSE 8080 4180

WORKDIR /opt/bitnami/oauth2-proxy
USER 1001
ENTRYPOINT [ "oauth2_proxy" ]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
