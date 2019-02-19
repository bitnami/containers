FROM bitnami/oraclelinux-runtimes:7-r238
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential bzip2-libs ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libffi libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline sqlite unzip wget xz-libs zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.6.8-1-linux-x86_64-ol-7.tar.gz && \
    echo "d330df2a1c10842ad2fe7cd52a974cfa02e3120ac9f972c821c9c048bd9fd38d  /tmp/bitnami/pkg/cache/python-3.6.8-1-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.6.8-1-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.6.8-1-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="3.6.8-ol-7-r54" \
    PATH="/opt/bitnami/python/bin:$PATH"

EXPOSE 8000

WORKDIR /app
CMD [ "python" ]
