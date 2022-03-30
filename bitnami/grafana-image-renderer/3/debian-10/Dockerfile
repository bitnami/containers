FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl fonts-freefont-ttf fonts-ipafont-gothic fonts-kacst fonts-thai-tlwg fonts-wqy-zenhei gnupg gzip jq libavahi-client3 libavahi-common3 libblkid1 libbsd0 libbz2-1.0 libc6 libcom-err2 libcups2 libdbus-1-3 libexpat1 libffi6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblz4-1 liblzma5 libmount1 libncursesw6 libnettle6 libp11-kit0 libpcre3 libreadline7 libselinux1 libsqlite3-0 libssl1.1 libstdc++6 libsystemd0 libtasn1-6 libtinfo6 libunistring2 libuuid1 libx11-6 libx11-xcb1 libxau6 libxcb-dri3-0 libxcb1 libxdmcp6 libxext6 libxshmfence1 libxss1 libxtst6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.8.13-2-linux-amd64-debian-10.tar.gz && \
    echo "704fe6b545280ae027303b4ec875b495ee6da2256b3d8f877467077b0f031a60  /tmp/bitnami/pkg/cache/python-3.8.13-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.8.13-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.8.13-2-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-14.19.1-0-linux-amd64-debian-10.tar.gz && \
    echo "806082b15c0eb60e4baca497519b4c0cc9cd636d7a944e9943ebc1b9632fabdc  /tmp/bitnami/pkg/cache/node-14.19.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-14.19.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-14.19.1-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-image-renderer-3.4.2-0-linux-amd64-debian-10.tar.gz && \
    echo "9c3c150a513ffc3a535619178d3dbafe583103994b44c90f67eca04ef6e8552f  /tmp/bitnami/pkg/cache/grafana-image-renderer-3.4.2-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-image-renderer-3.4.2-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-image-renderer-3.4.2-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list.d/google.list && \
    install_packages google-chrome-unstable

ENV APP_VERSION="3.4.2" \
    BITNAMI_APP_NAME="grafana-image-renderer" \
    BITNAMI_IMAGE_VERSION="3.4.2-debian-10-r6" \
    HTTP_HOST="0.0.0.0" \
    HTTP_PORT="8080" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:$PATH"

EXPOSE 3000 8080

WORKDIR /opt/bitnami/grafana-image-renderer
USER 1001
ENTRYPOINT [ "node" ]
CMD [ "build/app.js", "server", "--config=conf/config.json" ]
