FROM docker.io/bitnami/minideb:bullseye
ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="3.0.4-debian-11-r34" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/ruby" \
      org.opencontainers.image.title="ruby" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.0.4"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git gzip libc6 libcrypt1 libreadline-dev libreadline8 libsqlite3-dev libssl-dev libssl1.1 libtinfo6 pkg-config procps sqlite3 tar unzip wget zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f ruby-3.0.4-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/ruby-3.0.4-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "a0c64312075dfe1364bd5fc6fc290aef5c54707abe1a0a78877418aa79723914  ruby-3.0.4-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf ruby-3.0.4-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf ruby-3.0.4-153-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

ENV APP_VERSION="3.0.4" \
    BITNAMI_APP_NAME="ruby" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

EXPOSE 3000

WORKDIR /app
CMD [ "irb" ]
