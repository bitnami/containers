FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname libaio-devel procps-ng sudo tar which
RUN . ./libcomponent.sh && component_unpack "harbor-notary-server" "1.9.3-1" --checksum 17d0845d871e465b41db0d0cf22b5fe8bd0ed3f9aee14ee673b106029662bbb5

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-notary-server" \
    BITNAMI_IMAGE_VERSION="1.9.3-ol-7-r23" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-notary-server/bin:$PATH" \
    SERVICE_NAME="notary_server"

VOLUME [ "/etc/notary" ]

EXPOSE 4443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
