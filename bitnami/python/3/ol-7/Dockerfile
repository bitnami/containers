FROM bitnami/oraclelinux-runtimes:7-r0
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential bzip2-libs ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline sqlite unzip wget xz-libs zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.6.5-0-linux-x86_64-ol-7.tar.gz && \
    echo "2bd4a70747cbfb99c89f4d679b4474410612cb81bd9f2cec126f846b0fcf4749  /tmp/bitnami/pkg/cache/python-3.6.5-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.6.5-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.6.5-0-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="3.6.5-ol-7-r15" \
    PATH="/opt/bitnami/python/bin:$PATH"

EXPOSE 8000

WORKDIR /app
CMD ["python"]
