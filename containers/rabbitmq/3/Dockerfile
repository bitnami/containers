FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libssl1.0.0 libtinfo5 zlib1g
RUN bitnami-pkg install erlang-19.3.0-0 --checksum 7cb86885f3f0992f8f55f61680e548056ed105a5f1c63e239dc9d283a00d5a14
RUN bitnami-pkg unpack rabbitmq-3.6.11-6 --checksum ef8c1d514cc7a27732573a596a2ed7f2f88e82a5b5d08c70ae9a1941f2997ce6

COPY rootfs /

ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.6.11-r7" \
    PATH="/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:/opt/bitnami/rabbitmq/sbin:$PATH" \
    RABBITMQ_CLUSTER_NODE_NAME="" \
    RABBITMQ_CLUSTER_PARTITION_HANDLING="ignore" \
    RABBITMQ_DISK_FREE_LIMIT="{mem_relative, 1.0}" \
    RABBITMQ_ERLANG_COOKIE="" \
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
