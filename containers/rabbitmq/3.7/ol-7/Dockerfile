FROM bitnami/oraclelinux-extras-base:7-r419
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/opt/bitnami/rabbitmq/.rabbitmq" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc ncurses-libs openssl-libs zlib
RUN . ./libcomponent.sh && component_unpack "erlang" "22.0.0-0" --checksum 9ee71b514eacaf08de4f60fd3f80ffc969c65cc825f5e19cb8c12522289d5997
RUN . ./libcomponent.sh && component_unpack "rabbitmq" "3.7.17-0" --checksum 1875c6302b63ef6119bda0c52d764fc20e0ef498b0e80cdd0ab38831ee75ce29

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.7.17-ol-7-r52" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:/opt/bitnami/rabbitmq/sbin:$PATH"

EXPOSE 4369 5672 25672 15672

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
