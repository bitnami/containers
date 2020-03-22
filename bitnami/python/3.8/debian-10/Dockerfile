FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git libbz2-1.0 libc6 libffi6 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libsqlite3-dev libssl-dev libssl1.1 libtinfo6 pkg-config procps sudo unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.8.2-0-linux-amd64-debian-10.tar.gz && \
    echo "9c44d28ad9953b3b7b3f3b74501d7c703499a44d9ae00e78f7873a903b0c0d5e  /tmp/bitnami/pkg/cache/python-3.8.2-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/python-3.8.2-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/python-3.8.2-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="3.8.2-debian-10-r26" \
    PATH="/opt/bitnami/python/bin:$PATH"

EXPOSE 8000

WORKDIR /app
CMD [ "python" ]
