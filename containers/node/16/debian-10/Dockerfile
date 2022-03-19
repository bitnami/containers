FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git gzip libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libsqlite3-dev libssl-dev libssl1.1 libstdc++6 libtinfo6 pkg-config procps tar unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.8.13-1-linux-amd64-debian-10.tar.gz && \
    echo "2ac3d5028d8f8fc44cbf4b71e948458c1ae53c12a052ae62229fd52bf14191a6  /tmp/bitnami/pkg/cache/python-3.8.13-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.8.13-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.8.13-1-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-16.14.2-0-linux-amd64-debian-10.tar.gz && \
    echo "909790891401f3de89ccd2acc098c547f182b4014c6bfc96f9dca78c731ca336  /tmp/bitnami/pkg/cache/node-16.14.2-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-16.14.2-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-16.14.2-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="16.14.2-debian-10-r2" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:$PATH"

EXPOSE 3000

WORKDIR /app
CMD [ "node" ]
