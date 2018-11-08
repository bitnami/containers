FROM bitnami/minideb-runtimes:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git libbz2-1.0 libc6 libffi6 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libtinfo5 pkg-config unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.6.7-0-linux-amd64-debian-9.tar.gz && \
    echo "ba80577932fa081c340eb9e8f8b0832a43a8dac4e946d4632929aea7f41b9233  /tmp/bitnami/pkg/cache/python-3.6.7-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.6.7-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.6.7-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="3.6.7-debian-9-r11" \
    PATH="/opt/bitnami/python/bin:$PATH"

EXPOSE 8000

WORKDIR /app
CMD [ "python" ]
