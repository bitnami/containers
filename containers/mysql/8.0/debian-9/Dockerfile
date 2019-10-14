FROM bitnami/minideb-extras-base:stretch-r376
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libaio1 libc6 libgcc1 libncurses5 libsasl2-2 libssl1.1 libstdc++6 libtinfo5 zlib1g
RUN . ./libcomponent.sh && component_unpack "mysql" "8.0.18-0" --checksum 13252575055005fdd8a4a15a985e0ad586549f1e11fdd62afc325a0e16279198
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mysql" \
    BITNAMI_IMAGE_VERSION="8.0.18-debian-9-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mysql/bin:/opt/bitnami/mysql/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
