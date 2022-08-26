FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.6.0-debian-11-r3" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/harbor-registry" \
      org.opencontainers.image.title="harbor-registry" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.6.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-registry" "2.6.0-0" --checksum d7dd9255e6061b0ed1b97d94e466baf78c86e76dd1e66d2fefaf04c3e16a315a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-registry/postunpack.sh
ENV APP_VERSION="2.6.0" \
    BITNAMI_APP_NAME="harbor-registry" \
    PATH="/opt/bitnami/harbor-registry/bin:/opt/bitnami/common/bin:$PATH"

VOLUME [ "/etc/registry", "/storage", "/var/lib/registry" ]

EXPOSE 5000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-registry/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-registry/run.sh" ]
