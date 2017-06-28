FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libc6 libssl1.0.0 libtinfo5 zlib1g
RUN bitnami-pkg install erlang-19.3-0 --checksum f5af3ad6e91a63827a211167debd7213ff7643d67f4467944681309fad6c6a68
RUN bitnami-pkg unpack rabbitmq-3.6.10-0 --checksum 04d8e21b6f1b1fa265c36933bf38de2707722c78a3e9db080a3d73c356749d7d

COPY rootfs /

ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.6.10-r2" \
    PATH="/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/bin:/opt/bitnami/rabbitmq/sbin:$PATH" \
    RABBITMQ_CLUSTER_NODE_NAME="" \
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
