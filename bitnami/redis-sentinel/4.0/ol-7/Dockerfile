FROM bitnami/oraclelinux-extras-base:7-r470
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc
RUN . ./libcomponent.sh && component_unpack "redis-sentinel" "4.0.14-2" --checksum 19ae4a088fa036625590bdaf478471095d704304a43223f71699e25c6ce80755

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="redis-sentinel" \
    BITNAMI_IMAGE_VERSION="4.0.14-ol-7-r230" \
    PATH="/opt/bitnami/redis-sentinel/bin:$PATH"

EXPOSE 26379

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
