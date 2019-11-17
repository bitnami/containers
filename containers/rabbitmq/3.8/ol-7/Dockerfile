FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/opt/bitnami/rabbitmq/.rabbitmq" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname libaio-devel ncurses-libs openssl-libs procps-ng sudo tar which zlib
RUN . ./libcomponent.sh && component_unpack "erlang" "22.1.0-1" --checksum e3c861c70ab15fa6d3757f0d36af12f6f89c1f3bfc800e40654ecb4551436a0e
RUN . ./libcomponent.sh && component_unpack "rabbitmq" "3.8.1-0" --checksum 179ea11bd7245c9c6e19d5aebe13d8131949663be328bad926a1400e5f67f490

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.8.1-ol-7-r17" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:/opt/bitnami/rabbitmq/sbin:$PATH"

EXPOSE 4369 5672 25672 15672

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
