FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-registry" "2.3.0-0" --checksum 67f2a5eb57e98a8e81d7df1db1baf4e3b73c16aed4433c41b925ea29f61ae13d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "3.4.1-0" --checksum c88c76a7b5214407821771e5fc340f0320d5ded19eada938629603a982b8b640
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-registryctl" "2.3.0-0" --checksum 30eab0023d8761a446a0f214b8e959ed2e927b4c44c39c47fd84f4159be40c4f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-registryctl/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="2.3.0-debian-10-r27" \
    PATH="/opt/bitnami/harbor-registry/bin:/opt/bitnami/common/bin:/opt/bitnami/harbor-registryctl/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-registryctl/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-registryctl/run.sh" ]
