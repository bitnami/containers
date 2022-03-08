FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.21.1-1" --checksum d0927015892d9e13182fbf5242b41d75de0bf5eca43106bb1c0f0f936b05144a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-jobservice" "2.4.1-12" --checksum e556d7a21e1a8670253aee2fd82c00be6298514ab3a0b2fbdbbfb138a69257d4
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-jobservice/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-jobservice" \
    BITNAMI_IMAGE_VERSION="2.4.1-debian-10-r76" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/harbor-jobservice/bin:$PATH"

VOLUME [ "/etc/jobservice", "/var/log/jobs" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-jobservice/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-jobservice/run.sh" ]
