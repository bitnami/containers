FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.8.1-debian-11-r41" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kong" \
      org.opencontainers.image.title="kong" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.8.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libcrypt1 libgcc-s1 libpcre3 libprotobuf-dev libssl1.1 libyaml-0-2 perl procps tar zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kong" "2.8.1-18" --checksum 35ace39e3813d54bb352d3ef62496a517ab13e8f96d6524211d6b8ff331f55c0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/kong/postunpack.sh
ENV APP_VERSION="2.8.1" \
    BITNAMI_APP_NAME="kong" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/kong/bin:/opt/bitnami/kong/openresty/bin:/opt/bitnami/kong/openresty/luajit/bin:/opt/bitnami/kong/openresty/nginx/sbin:$PATH"

EXPOSE 8000 8001 8443 8444

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/kong/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/kong/run.sh" ]
