FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="6.2.7-debian-11-r30" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/redis" \
      org.opencontainers.image.title="redis" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="6.2.7"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libssl1.1 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-153" --checksum 8c8e324ab6e7b7d76b4655182d6ea5f6550edfc9e32bec92228e678c26fc8b16
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redis" "6.2.7-153" --checksum 5451fd2f4c7f1b721b5e38aaeaa054d5534b1169409ea9c7a5b0c41dafdc3333
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/redis/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/redis/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/redis/postunpack.sh
ENV APP_VERSION="6.2.7" \
    BITNAMI_APP_NAME="redis" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/redis/bin:$PATH"

EXPOSE 6379

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/redis/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redis/run.sh" ]
