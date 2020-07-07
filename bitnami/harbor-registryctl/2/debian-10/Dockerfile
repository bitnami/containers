FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-registry" "2.0.1-1" --checksum d768488cb3df9f9e25fce79e306a8b7eca87c2acfa1f1cd62c106b78cee7e9fc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "3.3.2-0" --checksum 50cac57ffd984455e7321d1f13380f94b6bda2a16b7e2547ba33aad347d5e9eb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-registryctl" "2.0.1-0" --checksum 9e1491f4ebab509c3997ed24a03f3a4779381a5d637b8ba7e81639c6632809fa
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-1" --checksum 51cfb1b7fd7b05b8abd1df0278c698103a9b1a4964bdacd87ca1d5c01631d59c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-registryctl/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="2.0.1-debian-10-r7" \
    PATH="/opt/bitnami/harbor-registry/bin:/opt/bitnami/common/bin:/opt/bitnami/harbor-registryctl/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-registryctl/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-registryctl/run.sh" ]
