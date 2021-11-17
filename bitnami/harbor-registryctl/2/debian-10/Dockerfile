FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-registry" "2.4.0-0" --checksum ecf7ef51730284bc4f132a095e02d033b752f575b9ff84fede3f87f9c57454a4
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.14.2-0" --checksum 603824903f6b3aa44fed08caeabf517f26e036319e6686c38effb2d61ec63505
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-registryctl" "2.4.0-0" --checksum a1ea3c8359e51e81abf1b3e9a245e38db6d735ad03565da4e2102f20af0fcf23
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-registryctl/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="2.4.0-debian-10-r20" \
    PATH="/opt/bitnami/harbor-registry/bin:/opt/bitnami/common/bin:/opt/bitnami/harbor-registryctl/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-registryctl/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-registryctl/run.sh" ]
