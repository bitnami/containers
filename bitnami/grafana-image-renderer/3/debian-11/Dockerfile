FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="3.5.0-debian-11-r13" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/grafana-image-renderer" \
      org.opencontainers.image.title="grafana-image-renderer" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.5.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl fonts-freefont-ttf fonts-ipafont-gothic fonts-kacst fonts-thai-tlwg fonts-wqy-zenhei gnupg gzip jq libasound2 libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libavahi-client3 libavahi-common3 libblkid1 libbrotli1 libbsd0 libbz2-1.0 libc6 libcairo2 libcom-err2 libcrypt1 libcups2 libdatrie1 libdbus-1-3 libdrm2 libexpat1 libffi7 libfontconfig1 libfreetype6 libfribidi0 libgbm1 libgcc-s1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgpg-error0 libgraphite2-3 libgssapi-krb5-2 libharfbuzz0b libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblz4-1 liblzma5 libmd0 libmount1 libncursesw6 libnettle8 libnsl2 libnspr4 libnss3 libp11-kit0 libpango-1.0-0 libpcre2-8-0 libpcre3 libpixman-1-0 libpng16-16 libreadline8 libselinux1 libsqlite3-0 libssl1.1 libstdc++6 libsystemd0 libtasn1-6 libthai0 libtinfo6 libtirpc3 libunistring2 libuuid1 libwayland-server0 libx11-6 libx11-xcb1 libxau6 libxcb-dri3-0 libxcb-render0 libxcb-shm0 libxcb1 libxcomposite1 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxkbcommon0 libxrandr2 libxrender1 libxshmfence1 libxss1 libxtst6 libzstd1 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.8.13-165-linux-amd64-debian-11.tar.gz && \
    echo "2bf41f60dccdcf65842d993083c2dcb27ab48a8a514fdeb1778e9b09f3e4a203  /tmp/bitnami/pkg/cache/python-3.8.13-165-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.8.13-165-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.8.13-165-linux-amd64-debian-11.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-14.20.0-2-linux-amd64-debian-11.tar.gz && \
    echo "127f7b97bd46468ce62bc5cd9868371ca2c4c1e7201f6271a309b34a17b97d90  /tmp/bitnami/pkg/cache/node-14.20.0-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-14.20.0-2-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-14.20.0-2-linux-amd64-debian-11.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-image-renderer-3.5.0-3-linux-amd64-debian-11.tar.gz && \
    echo "6ab11edfa04de2022b5a63caa6cb951362e62133a8207da45f40c2a9f46a71a6  /tmp/bitnami/pkg/cache/grafana-image-renderer-3.5.0-3-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-image-renderer-3.5.0-3-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-image-renderer-3.5.0-3-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list.d/google.list && \
    install_packages google-chrome-unstable

ENV APP_VERSION="3.5.0" \
    BITNAMI_APP_NAME="grafana-image-renderer" \
    HTTP_HOST="0.0.0.0" \
    HTTP_PORT="8080" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:$PATH"

EXPOSE 3000 8080

WORKDIR /opt/bitnami/grafana-image-renderer
USER 1001
ENTRYPOINT [ "node" ]
CMD [ "build/app.js", "server", "--config=conf/config.json" ]
