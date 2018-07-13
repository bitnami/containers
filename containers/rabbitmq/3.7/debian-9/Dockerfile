FROM bitnami/minideb-extras:stretch-r76
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libssl1.1 libtinfo5 zlib1g
RUN bitnami-pkg install erlang-20.3.0-0 --checksum ef51e356484706bb01e82ba67ae94c47c38c221d348f7694cb2f0c06eb0487f0
RUN bitnami-pkg unpack rabbitmq-3.7.7-0 --checksum 063bbd83ee9c9d455ac0624161539867a00cd2105142736e7d4bb2eaadbb0229

COPY rootfs /
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.7.7-debian-9-r7" \
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
