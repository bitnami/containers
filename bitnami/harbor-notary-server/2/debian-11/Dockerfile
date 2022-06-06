FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-notary-server" "2.5.1-0" --checksum f210d5cc97d6674ad7812564faaa66974e7ce31d44ad5b8f0c8b7cc1b08b7e98
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-notary-server/postunpack.sh
ENV APP_VERSION="2.5.1" \
    BITNAMI_APP_NAME="harbor-notary-server" \
    PATH="/opt/bitnami/harbor-notary-server/bin:/opt/bitnami/common/bin:$PATH" \
    SERVICE_NAME="notary_server"

VOLUME [ "/etc/notary" ]

EXPOSE 4443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-notary-server/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-notary-server/run.sh" ]
