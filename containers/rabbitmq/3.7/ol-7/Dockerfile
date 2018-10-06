FROM bitnami/oraclelinux-extras:7-r128
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/rabbitmq /opt/bitnami/rabbitmq/.rabbitmq" \
    HOME="/opt/bitnami/rabbitmq/.rabbitmq" \
    NAMI_PREFIX="/.nami"

# Install required system packages and dependencies
RUN install_packages glibc ncurses-libs openssl-libs zlib
RUN bitnami-pkg install erlang-21.1.0-0 --checksum 22447de33b57eac1ce6b22cc0a153677c9dfa4ee134b1c9bdc3661b7e27b3f5a
RUN bitnami-pkg unpack rabbitmq-3.7.8-3 --checksum bd817850a786dffc8477227007e6229741f02aa21cb7a638ab1e2967a2624ae4
RUN mkdir -p /opt/bitnami/rabbitmq/.rabbitmq && mkdir -p /opt/bitnami/rabbitmq/var/log/rabbitmq && chmod g+rwX -R /opt/bitnami/rabbitmq/.rabbitmq /opt/bitnami/rabbitmq/var

COPY rootfs /
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.7.8-ol-7-r19" \
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
