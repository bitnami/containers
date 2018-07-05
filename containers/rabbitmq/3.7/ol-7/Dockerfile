FROM bitnami/oraclelinux-extras:7-r26
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glibc ncurses-libs openssl-libs zlib
RUN bitnami-pkg install erlang-20.3.0-0 --checksum c38b4ba132784a8a9d180b7a1c94b99e2713dd32e425c3b1276ef45486dcb520
RUN bitnami-pkg unpack rabbitmq-3.7.7-0 --checksum 4ccdbc6d9b97a053b01ac6287438217b71ba5cb64bdf8a164414d431172bc094

COPY rootfs /
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.7.7-ol-7-r0" \
    PATH="/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:/opt/bitnami/rabbitmq/sbin:$PATH" \
    RABBITMQ_CLUSTER_NODE_NAME="" \
    RABBITMQ_CLUSTER_PARTITION_HANDLING="ignore" \
    RABBITMQ_DISK_FREE_LIMIT="{mem_relative, 1.0}" \
    RABBITMQ_ERL_COOKIE="" \
    RABBITMQ_MANAGER_PORT_NUMBER="15672" \
    RABBITMQ_NODE_NAME="rabbit@localhost" \
    RABBITMQ_NODE_PORT_NUMBER="5672" \
    RABBITMQ_NODE_TYPE="stats" \
    RABBITMQ_PASSWORD="bitnami" \
    RABBITMQ_USERNAME="user" \
    RABBITMQ_VHOST="/"

EXPOSE 4369 5672 25672 15672

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","rabbitmq"]
