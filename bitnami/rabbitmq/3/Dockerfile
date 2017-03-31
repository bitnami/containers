FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=rabbitmq \
    BITNAMI_IMAGE_VERSION=3.6.9-r0 \
    PATH=/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/sbin:/opt/bitnami/rabbitmq/bin:$PATH

# System packages required
RUN install_packages libc6 libssl1.0.0 libtinfo5 zlib1g

# Additional modules required
RUN bitnami-pkg install erlang-17.4-3 --checksum 7465a1ac11bf98cc1e2a549758dd4fccb2812d60ede33d1f68e0c7ec312b0b88

# Install rabbitmq
RUN bitnami-pkg unpack rabbitmq-3.6.9-0 --checksum d3f26d9e9a737508fa6d73869fc5f9f748b61a9d1d8e6b6a4677a6c4a6d62696

COPY rootfs /

ENV RABBITMQ_VHOST="/" \
    RABBITMQ_USERNAME="user" \
    RABBITMQ_PASSWORD="bitnami" \
    RABBITMQ_NODE_TYPE="stats" \
    RABBITMQ_NODE_PORT="5672" \
    RABBITMQ_NODE_NAME="rabbit@localhost" \
    RABBITMQ_MANAGER_PORT="15672"

VOLUME ["/bitnami/rabbitmq"]

EXPOSE 4369 5672 25672 15672

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "rabbitmq"]
