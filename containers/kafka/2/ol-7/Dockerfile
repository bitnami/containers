FROM bitnami/oraclelinux-extras-base:7-r458
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc libgcc zlib
RUN . ./libcomponent.sh && component_unpack "java" "1.8.232-0" --checksum fbac74363c807fce14538c5f9a9232602adc7883c1c5936571c741625de2479e
RUN . ./libcomponent.sh && component_unpack "kafka" "2.3.0-1" --checksum a1ed290d5e7b70913421a224b2d30d08199281a7bbc299eedd6f874a93cb5387

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="kafka" \
    BITNAMI_IMAGE_VERSION="2.3.0-ol-7-r131" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/kafka/bin:$PATH"

EXPOSE 9092

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
