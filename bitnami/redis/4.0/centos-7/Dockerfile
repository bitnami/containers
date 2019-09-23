FROM bitnami/centos-extras-base:7-r150
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="centos-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc
RUN . ./libcomponent.sh && component_unpack "redis" "4.0.14-2" --checksum 90580c36823d886b9d2904c8cec7da6305b634756377fe41b69664644e7163c0

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="redis" \
    BITNAMI_IMAGE_VERSION="4.0.14-centos-7-r126" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/redis/bin:$PATH"

EXPOSE 6379

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
