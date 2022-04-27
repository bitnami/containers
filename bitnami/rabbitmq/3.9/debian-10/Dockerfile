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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "erlang" "24.3.3-0" --checksum ab2a407d35b2c460897cc224751e7404181f3f9050491de93b9916419dae81de
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "rabbitmq" "3.9.16-0" --checksum be8b839b49606046e42fef87b47b000112f86352c2dec29a7216df0a65406b5b
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
ENV APP_VERSION="3.9.16" \
    BITNAMI_APP_NAME="rabbitmq" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en"

EXPOSE 4369 5551 5552 5671 5672 15671 15672 25672

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/rabbitmq/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/rabbitmq/run.sh" ]
