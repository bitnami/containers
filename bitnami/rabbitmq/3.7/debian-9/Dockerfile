FROM bitnami/minideb-extras-base:stretch-r362
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/opt/bitnami/rabbitmq/.rabbitmq" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libssl1.1 libtinfo5 locales zlib1g
RUN . ./libcomponent.sh && component_unpack "erlang" "22.0.0-0" --checksum 7cfdf355fa71ea526890260cabc410bb994be15829e1c5ce433bfd3c2f236420
RUN . ./libcomponent.sh && component_unpack "rabbitmq" "3.7.17-0" --checksum 9d9c64d81941be2c67f5d1ddd01164a3fc0e8e5539416d221a038ddc845632c6
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.7.17-debian-9-r52" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:/opt/bitnami/rabbitmq/sbin:$PATH"

EXPOSE 4369 5672 25672 15672

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
