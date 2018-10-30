FROM bitnami/minideb-extras:stretch-r182
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/rabbitmq /opt/bitnami/rabbitmq/.rabbitmq" \
    HOME="/opt/bitnami/rabbitmq/.rabbitmq" \
    NAMI_PREFIX="/.nami"

# Install required system packages and dependencies
RUN install_packages libc6 libssl1.1 libtinfo5 zlib1g
RUN bitnami-pkg install erlang-21.1.0-1 --checksum 0536586652d92672f0d667d5374d2380eb20f51228bd317cc5454366691c1eac
RUN bitnami-pkg unpack rabbitmq-3.7.8-4 --checksum 7306514cf014f909b18aaf0b3dad3bb5e7d5443e4394bac522422d238c1214c5
RUN mkdir -p /opt/bitnami/rabbitmq/.rabbitmq && mkdir -p /opt/bitnami/rabbitmq/var/log/rabbitmq && chmod g+rwX -R /opt/bitnami/rabbitmq/.rabbitmq /opt/bitnami/rabbitmq/var

COPY rootfs /
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.7.8-debian-9-r36" \
    PATH="/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:/opt/bitnami/rabbitmq/sbin:$PATH" \
    RABBITMQ_CLUSTER_NODE_NAME="" \
    RABBITMQ_CLUSTER_PARTITION_HANDLING="ignore" \
    RABBITMQ_DISK_FREE_LIMIT="{mem_relative, 1.0}" \
    RABBITMQ_ERL_COOKIE="" \
    RABBITMQ_HASHED_PASSWORD="" \
    RABBITMQ_MANAGER_PORT_NUMBER="15672" \
    RABBITMQ_NODE_NAME="rabbit@localhost" \
    RABBITMQ_NODE_PORT_NUMBER="5672" \
    RABBITMQ_NODE_TYPE="stats" \
    RABBITMQ_PASSWORD="bitnami" \
    RABBITMQ_USERNAME="user" \
    RABBITMQ_VHOST="/"

EXPOSE 4369 5672 25672 15672

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "rabbitmq" ]
