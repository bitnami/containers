FROM bitnami/oraclelinux-extras-base:7-r447
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/opt/bitnami/rabbitmq/.rabbitmq" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc ncurses-libs openssl-libs zlib
RUN . ./libcomponent.sh && component_unpack "erlang" "22.1.0-1" --checksum e3c861c70ab15fa6d3757f0d36af12f6f89c1f3bfc800e40654ecb4551436a0e
RUN . ./libcomponent.sh && component_unpack "rabbitmq" "3.8.0-0" --checksum 51427979c2b331ed243899d4f5cdbaf6d9c5d836d79ccd535655bee0f181f8b9

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.8.0-ol-7-r5" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:/opt/bitnami/rabbitmq/sbin:$PATH"

EXPOSE 4369 5672 25672 15672

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
