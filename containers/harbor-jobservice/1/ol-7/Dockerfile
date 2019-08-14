FROM bitnami/oraclelinux-extras-base:7-r378
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc
RUN . ./libcomponent.sh && component_unpack "harbor-jobservice" "1.8.1-0" --checksum 8da824694c5a8a1b79b0af718624b9d81cf81b431435292152129d077737d457

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-jobservice" \
    BITNAMI_IMAGE_VERSION="1.8.1-ol-7-r22" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-jobservice/bin:$PATH"

VOLUME [ "/etc/jobservice", "/var/log/jobs/" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
