FROM bitnami/oraclelinux-extras-base:7-r421
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/opt/bitnami/rabbitmq/.rabbitmq" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc ncurses-libs openssl-libs zlib
RUN . ./libcomponent.sh && component_unpack "erlang" "22.1.0-0" --checksum ee441c626910944178716ae352b9647ec59130d2b54e6c87ce1eec095f0d204b
RUN . ./libcomponent.sh && component_unpack "rabbitmq" "3.7.18-0" --checksum 2e105f1eaaab3fd29a7a6ebe26dade81d805e86e9da8a257c0cf17dc6ee0982e

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.7.18-ol-7-r1" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:/opt/bitnami/rabbitmq/sbin:$PATH"

EXPOSE 4369 5672 25672 15672

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
