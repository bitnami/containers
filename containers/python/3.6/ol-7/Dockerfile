FROM bitnami/oraclelinux-runtimes:7-r35
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential bzip2-libs ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libffi libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline sqlite unzip wget xz-libs zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.6.6-0-linux-x86_64-ol-7.tar.gz && \
    echo "1bf0fa90bf6782e3ff638b7b1b74b384b546ed0d89d81a558a7536d2f528a2d8  /tmp/bitnami/pkg/cache/python-3.6.6-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.6.6-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.6.6-0-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="3.6.6-ol-7-r0" \
    PATH="/opt/bitnami/python/bin:$PATH"

EXPOSE 8000

WORKDIR /app
CMD ["python"]
