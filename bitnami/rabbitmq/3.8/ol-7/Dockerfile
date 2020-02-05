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
RUN . ./libcomponent.sh && component_unpack "erlang" "22.2.0-0" --checksum 86910fb626e9b48438f0967c3055638687f390825e33e4d418aeaea74d75f01b
RUN . ./libcomponent.sh && component_unpack "rabbitmq" "3.8.2-0" --checksum f2ba2bc161591afbb60dfa34b406b1b418c1e770b7f24a8f7689bdc4a81b7dd5
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.8.2-ol-7-r61" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:/opt/bitnami/rabbitmq/sbin:$PATH"

EXPOSE 4369 5672 25672 15672

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
