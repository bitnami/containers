FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="3.3.27-debian-11-r28" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/etcd" \
      org.opencontainers.image.title="etcd" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.3.27"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.27.2-1" --checksum 44d0058c0fffa1ccc89c081ed3e5c897489fa02580a839cfe1d37b2ca771f237
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "etcd" "3.3.27-153" --checksum 6ab00dce025237b5894168486479b01de86432c93b740aacc2eac76b9fe2f566
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/etcd/postunpack.sh
ENV APP_VERSION="3.3.27" \
    BITNAMI_APP_NAME="etcd" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/etcd/bin:$PATH"

EXPOSE 2379 2380

WORKDIR /opt/bitnami/etcd
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/etcd/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/etcd/run.sh" ]
