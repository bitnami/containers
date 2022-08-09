FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-153" --checksum 8c8e324ab6e7b7d76b4655182d6ea5f6550edfc9e32bec92228e678c26fc8b16
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.3-152" --checksum 0017b950b7eb0faa7580ef23342adbbfa2038d55c3dafdf1c8761788122f718e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-core" "2.5.3-2" --checksum 3c76b3a36f90355f549859b60e8f29031f3f8e0943a84082a33fceccb8c12e40
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-core/postunpack.sh
ENV APP_VERSION="2.5.3" \
    BITNAMI_APP_NAME="harbor-core" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/harbor-core/bin:$PATH"

VOLUME [ "/data", "/etc/core" ]

EXPOSE 8080

WORKDIR /opt/bitnami/harbor-core
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-core/entrypoint.sh" ]
CMD [ "harbor_core" ]
