FROM bitnami/minideb-extras-base:stretch-r325
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6
RUN . ./libcomponent.sh && component_unpack "harbor-notary-server" "1.8.2-rc1-1" --checksum f14da6b2f9cb2123c225d60f1feca1f2bc1912c241de89dad11f66e18e55351b

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-notary-server" \
    BITNAMI_IMAGE_VERSION="1.8.2-rc1-debian-9-r19" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-notary-server/bin:$PATH" \
    SERVICE_NAME="notary_server"

VOLUME [ "/etc/notary" ]

EXPOSE 4443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
