FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="5.2.5-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/parse" \
      org.opencontainers.image.title="parse" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="5.2.5"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libtirpc3 procps tar zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f python-3.8.13-167-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/python-3.8.13-167-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "6e21552dc6c19b01247f3ec7bcd0401e6192519fe206e136e205ac6c3b842e7b  python-3.8.13-167-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf python-3.8.13-167-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf python-3.8.13-167-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f node-14.20.0-3-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/node-14.20.0-3-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "49946e0443d8f479f296c79589fea205126b6f6faa6b4474e5dd713b36d8167c  node-14.20.0-3-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf node-14.20.0-3-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf node-14.20.0-3-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f mongodb-shell-1.5.4-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/mongodb-shell-1.5.4-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "77e3526b982f5fc7160827d41d2fae83a4c3dd3c88dec6fa2b2ce4cbb0078ef8  mongodb-shell-1.5.4-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf mongodb-shell-1.5.4-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf mongodb-shell-1.5.4-2-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f parse-5.2.5-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/parse-5.2.5-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "a204640c889ae57e0e22ad2b15c128fbec66ca0cac2af784cbe33eed722ef9bc  parse-5.2.5-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf parse-5.2.5-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf parse-5.2.5-0-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab  gosu-1.14.0-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/parse/postunpack.sh
ENV APP_VERSION="5.2.5" \
    BITNAMI_APP_NAME="parse" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 1337 3000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/parse/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/parse/run.sh" ]
