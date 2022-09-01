FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.2.0-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/gramine-redis-intel" \
      org.opencontainers.image.title="gramine-redis-intel" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.2.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl binutils ca-certificates curl gzip libbrotli1 libbz2-1.0 libc6 libcom-err2 libcrypt1 libcurl4 libffi7 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle8 libnghttp2-14 libnsl2 libp11-kit0 libprotobuf-c1 libpsl5 libreadline8 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libtirpc3 libunistring2 procps tar zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f redis-7.0.4-3-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/redis-7.0.4-3-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "88d418ff4ced6262a27a1ea18294e410110dc8c4ad5449d3ae7d6fa9e087b6ba  redis-7.0.4-3-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf redis-7.0.4-3-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf redis-7.0.4-3-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f python-3.10.6-8-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/python-3.10.6-8-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "84801ae4aee44f17012410d30a7d45e7e30ff842469fea2e5196050142713efc  python-3.10.6-8-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf python-3.10.6-8-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf python-3.10.6-8-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gramine-redis-intel-1.2.0-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gramine-redis-intel-1.2.0-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "b5edda10ef261a0052e8400a8a83cc473fb5496ccde5ef4630a00ec0ec3e0af1  gramine-redis-intel-1.2.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf gramine-redis-intel-1.2.0-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gramine-redis-intel-1.2.0-0-linux-amd64-debian-11.tar.gz
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
RUN /opt/bitnami/scripts/gramine-redis-intel/postunpack.sh
ENV APP_VERSION="1.2.0" \
    BITNAMI_APP_NAME="gramine-redis-intel" \
    LD_LIBRARY_PATH="/opt/bitnami/gramine-intel/lib/x86_64-linux-gnu:/opt/bitnami/gramine-intel/lib/x86_64-linux-gnu/gramine/sgx:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/redis/bin:/opt/bitnami/python/bin:/opt/bitnami/gramine-redis-intel/bin:/opt/bitnami/common/bin:/opt/bitnami/gramine-intel/bin:$PATH"

EXPOSE 6379

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/gramine-redis-intel/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/gramine-redis-intel/run.sh" ]
