FROM bitnami/minideb-extras-base:stretch-r370
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgeoip1 libpcre3 libssl1.1 zlib1g
RUN . ./libcomponent.sh && component_unpack "nginx" "1.16.1-2" --checksum 9d8592ed4d88b4b6d3d6480a63f39edecb1dc79bead112849717f8243a488b9a
RUN . ./libcomponent.sh && component_unpack "harbor" "1.9.0-1" --checksum 35b07dbd47a1bcbf5c27df12d65ee45029a5ba07ca1e6da4db2df7ee54829cbf
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log
RUN chmod -R g+rwX /opt/bitnami/nginx/conf

COPY rootfs /
RUN /postunpack.sh
RUN /postunpack-harbor-portal.sh
ENV BITNAMI_APP_NAME="harbor-portal" \
    BITNAMI_IMAGE_VERSION="1.9.0-debian-9-r1" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/nginx/sbin:/opt/bitnami/harbor/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /opt/bitnami/harbor
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
