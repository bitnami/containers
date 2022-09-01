FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="5.12.3-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/ghost" \
      org.opencontainers.image.title="ghost" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="5.12.3"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libaudit1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgssapi-krb5-2 libicu67 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncurses6 libncursesw6 libnsl2 libpam0g libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libtirpc3 libxml2 procps tar zlib1g
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
    if [ ! -f mysql-client-10.6.9-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/mysql-client-10.6.9-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "14ae2f6d8d5f4e3a9e4cf62d5a3da80587a20651a5920dbc4ac89afdaf06f8c0  mysql-client-10.6.9-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf mysql-client-10.6.9-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf mysql-client-10.6.9-1-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab  gosu-1.14.0-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f ghost-5.12.3-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/ghost-5.12.3-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "684a133602031e838d345eb2bb8fa52c83a19007beccd08a092a58b80f012956  ghost-5.12.3-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf ghost-5.12.3-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf ghost-5.12.3-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/ghost/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
ENV APP_VERSION="5.12.3" \
    BITNAMI_APP_NAME="ghost" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:/opt/bitnami/ghost/bin:$PATH"

EXPOSE 2368 3000

WORKDIR /opt/bitnami/ghost
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/ghost/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/ghost/run.sh" ]
