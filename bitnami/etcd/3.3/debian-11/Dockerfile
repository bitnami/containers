FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="3.3.27-debian-11-r31" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/etcd" \
      org.opencontainers.image.title="etcd" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.3.27"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.27.2-2" --checksum 4c7e134b8eb804da5b3fa007bc75d08ddb7bf1d9d6dd3fffb5c18ae3c8ec54d5
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "etcd" "3.3.27-154" --checksum 6c4ccbe59fa69f871756444085144fcebe053f2d4ad6a46742637f0b0c2e66e4
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/etcd/postunpack.sh
ENV APP_VERSION="3.3.27" \
    BITNAMI_APP_NAME="etcd" \
    ETCDCTL_API="3" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/etcd/bin:$PATH"

EXPOSE 2379 2380

WORKDIR /opt/bitnami/etcd
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/etcd/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/etcd/run.sh" ]
