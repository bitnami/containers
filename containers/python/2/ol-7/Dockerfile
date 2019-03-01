FROM bitnami/oraclelinux-runtimes:7-r247
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl gcc gcc-c++ git glibc keyutils-libs krb5-libs libcom_err libselinux libtool make ncurses-libs nss-softokn-freebl openssl-libs patch pcre pkgconfig readline sqlite unzip wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-2.7.15-20-linux-x86_64-ol-7.tar.gz && \
    echo "74fe4964d24180d043f2ee328097a414c69ac7c955cfad228057bbeb9b4ab96f  /tmp/bitnami/pkg/cache/python-2.7.15-20-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-2.7.15-20-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-2.7.15-20-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="2.7.15-ol-7-r226" \
    PATH="/opt/bitnami/python/bin:$PATH"

EXPOSE 8000

WORKDIR /app
CMD [ "python" ]
