FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-notary-server" "2.4.1-1" --checksum f8d9b7ceb0d042faa0273d2c7a1370676f38ec27313fdc0bce32e574fe7164f2
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-1" --checksum 16f1a317859b06ae82e816b30f98f28b4707d18fe6cc3881bff535192a7715dc
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-notary-server/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-notary-server" \
    BITNAMI_IMAGE_VERSION="2.4.1-debian-10-r24" \
    PATH="/opt/bitnami/harbor-notary-server/bin:/opt/bitnami/common/bin:$PATH" \
    SERVICE_NAME="notary_server"

VOLUME [ "/etc/notary" ]

EXPOSE 4443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-notary-server/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-notary-server/run.sh" ]
