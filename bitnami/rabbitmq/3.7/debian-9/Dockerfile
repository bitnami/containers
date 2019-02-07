FROM bitnami/minideb-extras:stretch-r277
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/rabbitmq /opt/bitnami/rabbitmq/.rabbitmq" \
    HOME="/opt/bitnami/rabbitmq/.rabbitmq" \
    NAMI_PREFIX="/.nami"

# Install required system packages and dependencies
RUN install_packages libc6 libssl1.1 libtinfo5 zlib1g
RUN bitnami-pkg install erlang-21.2.0-0 --checksum 3f3dfdec897f08210b4854e5f6cfdde77511902ce3dd03c2c5e9a0e599f04d49
RUN bitnami-pkg unpack rabbitmq-3.7.11-0 --checksum d4f84dd036665f1676ee8c857c48eb7b8c14580fed4d472f75a5757e0291570e
RUN mkdir -p /opt/bitnami/rabbitmq/.rabbitmq && mkdir -p /opt/bitnami/rabbitmq/var/log/rabbitmq && chmod g+rwX -R /opt/bitnami/rabbitmq/.rabbitmq /opt/bitnami/rabbitmq/var

COPY rootfs /
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.7.11-debian-9-r4" \
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
