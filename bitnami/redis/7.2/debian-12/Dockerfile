FROM docker.io/bitnami/minideb:bookworm
ARG TARGETARCH
LABEL org.opencontainers.image.title="redis" \
      org.opencontainers.image.version="7.2.10" \
      org.opencontainers.image.licenses="Apache-2.0"
ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"
COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]

# Install required system packages and dependencies for building Redis and wait-for-port
RUN install_packages ca-certificates curl libgomp1 libssl-dev procps build-essential pkg-config golang-go

# This was copied from an existing running instance
COPY redis-default.conf /opt/bitnami/redis/etc/redis-default.conf

# Download and build Redis from official source
RUN mkdir -p /tmp/redis && cd /tmp/redis && \
    curl -SsLf "http://download.redis.io/releases/redis-7.2.10.tar.gz" -o redis-7.2.10.tar.gz && \
    tar -zxf redis-7.2.10.tar.gz && \
    cd redis-7.2.10 && \
    make BUILD_TLS=yes && \
    make install PREFIX=/opt/bitnami/redis && \
    mkdir -p /opt/bitnami/redis/etc && \
    cd / && \
    rm -rf /tmp/redis

# Build wait-for-port from source
RUN mkdir -p /tmp/wait-for-port && cd /tmp/wait-for-port && \
    curl -SsLf "https://github.com/bitnami/wait-for-port/archive/refs/tags/v1.0.7.tar.gz" -o wait-for-port.tar.gz && \
    tar -zxf wait-for-port.tar.gz && \
    cd wait-for-port-1.0.7 && \
    go build -o wait-for-port . && \
    mkdir -p /opt/bitnami/common/bin && \
    mv wait-for-port /opt/bitnami/common/bin/ && \
    chmod +x /opt/bitnami/common/bin/wait-for-port && \
    cd / && \
    rm -rf /tmp/wait-for-port

# Clean up build dependencies and packages
RUN apt-get autoremove --purge -y curl build-essential pkg-config golang-go && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN ln -s /opt/bitnami/scripts/redis/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/redis/run.sh /run.sh
COPY rootfs /
RUN /opt/bitnami/scripts/redis/postunpack.sh
ENV APP_VERSION="7.2.10" \
    BITNAMI_APP_NAME="redis" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/redis/bin:$PATH"
EXPOSE 6379
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/redis/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redis/run.sh" ]
