FROM bitnami/minideb-extras-base:stretch-r379
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6
RUN . ./libcomponent.sh && component_unpack "redis-sentinel" "5.0.7-0" --checksum 43072207f21a056b99406af3dee1cdce73b91f12c03a977ce09c1603e24eee8f

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="redis-sentinel" \
    BITNAMI_IMAGE_VERSION="5.0.7-debian-9-r0" \
    PATH="/opt/bitnami/redis-sentinel/bin:$PATH"

EXPOSE 26379

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
