FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-registry" "2.4.1-36" --checksum 6d024fe534d2237367325e2fc79f8dedc5b0af3ca2b0b85f972e227b8fe54b2e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.22.1-0" --checksum 9b8c8ea8b9074c1f94e0e87cf934f052da35e1655d80b4c2afad665541670425
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-registryctl" "2.4.1-10" --checksum 40bb5176ad7fc7b5f0ef2d54ac13b3b96a68f7bf942e637b31e7ef2db1f9ba02
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-registryctl/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="2.4.1-debian-10-r88" \
    PATH="/opt/bitnami/harbor-registry/bin:/opt/bitnami/common/bin:/opt/bitnami/harbor-registryctl/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-registryctl/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-registryctl/run.sh" ]
