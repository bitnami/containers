FROM bitnami/minideb-extras-base:stretch-r379
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6
RUN . ./libcomponent.sh && component_unpack "redis-sentinel" "4.0.14-2" --checksum 6b9f1e5caf24d5277bdf20110f25646f0b968e4759afddb4d3e36aae65c583f6

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="redis-sentinel" \
    BITNAMI_IMAGE_VERSION="4.0.14-debian-9-r216" \
    PATH="/opt/bitnami/redis-sentinel/bin:$PATH"

EXPOSE 26379

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
