FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl ghostscript git imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 pkg-config unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-8.11.3-0-linux-x64-debian-8.tar.gz && \
    echo "e8a276dcff0eb7c501f7c8ba7bd3df532886faf31701fa83c4ab0d7614b4bef2  /tmp/bitnami/pkg/cache/node-8.11.3-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-8.11.3-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-8.11.3-0-linux-x64-debian-8.tar.gz

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="8.11.3-debian-8-r20" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

EXPOSE 3000

WORKDIR /app
CMD ["node"]
