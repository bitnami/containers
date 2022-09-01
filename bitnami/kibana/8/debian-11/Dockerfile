FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/kibana/bin:$PATH"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="8.4.1-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kibana" \
      org.opencontainers.image.title="kibana" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="8.4.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libexpat1 libgcc-s1 libnss3 libstdc++6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f yq-4.27.3-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/yq-4.27.3-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "1aa32d853f4ba273642dc4bb9fb50146434f2c44978d02e1728f72a047e50567  yq-4.27.3-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf yq-4.27.3-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf yq-4.27.3-0-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab  gosu-1.14.0-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kibana-8.4.1-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kibana-8.4.1-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "4d3bc3e13dcf61c64d3bfd229d251f6f23b40299d578efad5329221129c497be  kibana-8.4.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf kibana-8.4.1-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf kibana-8.4.1-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/kibana/postunpack.sh
ENV APP_VERSION="8.4.1" \
    BITNAMI_APP_NAME="kibana"

EXPOSE 5601

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/kibana/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/kibana/run.sh" ]
