FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-0" --checksum 1013e2ebbe58e5dc8f3c79fc952f020fc5306ba48463803cacfbed7779173924
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.3-0" --checksum ef1f6d1ca9e4873f82cf5037078b55524596ca2755262948f23571767bfd4101
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-core" "2.5.1-0" --checksum 74581cf03e13bc649cff6bd30089a77a82623e055850f92fb210884532adcef7
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-core/postunpack.sh
ENV APP_VERSION="2.5.1" \
    BITNAMI_APP_NAME="harbor-core" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/harbor-core/bin:$PATH"

VOLUME [ "/data", "/etc/core" ]

EXPOSE 8080

WORKDIR /opt/bitnami/harbor-core
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-core/entrypoint.sh" ]
CMD [ "harbor_core" ]
