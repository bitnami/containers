FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/opt/bitnami/rabbitmq/.rabbitmq" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libssl1.1 libtinfo6 locales procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "erlang" "22.2.0-0" --checksum ea76d2cdfa4cfe10a69c2f528cb1880caad9fdab5be368eb31d62bcbe63c094f
RUN . ./libcomponent.sh && component_unpack "rabbitmq" "3.8.2-0" --checksum 30b4a8a4cbffd77cebb6c89c455812530a12aaac2e1bb350fdc3756b55833161
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.8.2-debian-10-r6" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:/opt/bitnami/rabbitmq/sbin:$PATH"

EXPOSE 4369 5672 25672 15672

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
