FROM bitnami/minideb-extras-base:stretch-r375
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/opt/bitnami/rabbitmq/.rabbitmq" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libssl1.1 libtinfo5 locales zlib1g
RUN . ./libcomponent.sh && component_unpack "erlang" "22.1.0-1" --checksum decd14af45d2185862fb271330f92b593c574ec5c7129473fa1c8fc7d14589dc
RUN . ./libcomponent.sh && component_unpack "rabbitmq" "3.7.19-0" --checksum 1153ad66b27d5c0de47d3cd2d4aa381845913c9bf183de8b1a7e3a440c963f09
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.7.19-debian-9-r0" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:/opt/bitnami/rabbitmq/sbin:$PATH"

EXPOSE 4369 5672 25672 15672

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
