FROM bitnami/minideb-extras-base:stretch-r345
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "1.8.222-0" --checksum e5a677e160c01cd605bc6aae75cc937d4b2d37514b3e1d0a1dd2d332422e68c7
RUN . ./libcomponent.sh && component_unpack "zookeeper" "3.5.5-4" --checksum 82e99f2555a61a0782f92172f8d9942f1bfd84fe243e6ca4a04ccaa0aa5571b6

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="zookeeper" \
    BITNAMI_IMAGE_VERSION="3.5.5-debian-9-r95" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/zookeeper/bin:$PATH"

EXPOSE 2181 2888 3888 8080

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
