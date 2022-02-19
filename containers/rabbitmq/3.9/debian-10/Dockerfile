FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/opt/bitnami/rabbitmq/.rabbitmq" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/sbin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 libssl1.1 libstdc++6 libtinfo6 locales procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-6" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "erlang" "24.2.1-3" --checksum 56e8b94e38bdea3879e819f3f7e85cb5b8b662185185b369d9573ee62b67a3d8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "rabbitmq" "3.9.13-6" --checksum 48119face1f619be3864d64ec39c42654c5ad87cf6ed6e4d2fbbc8151a27cda3
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY rootfs /
RUN /opt/bitnami/scripts/rabbitmq/postunpack.sh
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.9.13-debian-10-r32" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en"

EXPOSE 4369 5551 5552 5671 5672 15671 15672 25672

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/rabbitmq/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/rabbitmq/run.sh" ]
