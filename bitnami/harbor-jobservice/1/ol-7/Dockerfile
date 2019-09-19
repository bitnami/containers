FROM bitnami/oraclelinux-extras-base:7-r422
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc
RUN . ./libcomponent.sh && component_unpack "harbor-jobservice" "1.9.0-0" --checksum bc28f92a020b08f67f2fb63c9912ba292cbed7df0f8542c5cd0ad6355b6533d8

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-jobservice" \
    BITNAMI_IMAGE_VERSION="1.9.0-ol-7-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-jobservice/bin:$PATH"

VOLUME [ "/etc/jobservice", "/var/log/jobs/" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
