FROM bitnami/minideb-extras:stretch-r387
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1
RUN bitnami-pkg install java-1.8.212-0 --checksum 54a18672c8b4c1a44324c607a6bc616f614a062005d5e3384f91f10ff6f6edea
RUN bitnami-pkg unpack kafka-1.1.1-29 --checksum 0a65ffd9015b7899018dd17e3525e090e567a144a7d6256a3cc5f57cc4bf373b

COPY rootfs /
ENV ALLOW_PLAINTEXT_LISTENER="no" \
    BITNAMI_APP_NAME="kafka" \
    BITNAMI_IMAGE_VERSION="1.1.1-debian-9-r221" \
    KAFKA_BROKER_PASSWORD="bitnami" \
    KAFKA_BROKER_USER="user" \
    KAFKA_CERTIFICATE_PASSWORD="" \
    KAFKA_CFG_ADVERTISED_LISTENERS="PLAINTEXT://:9092" \
    KAFKA_CFG_BROKER_ID="-1" \
    KAFKA_CFG_LISTENERS="PLAINTEXT://:9092" \
    KAFKA_CFG_LOG_DIRS="/opt/bitnami/kafka/data" \
    KAFKA_CFG_ZOOKEEPER_CONNECT="localhost:2181" \
    KAFKA_HEAP_OPTS="-Xmx1024m -Xms1024m" \
    KAFKA_INTER_BROKER_PASSWORD="bitnami" \
    KAFKA_INTER_BROKER_USER="admin" \
    KAFKA_PORT_NUMBER="9092" \
    KAFKA_ZOOKEEPER_PASSWORD="" \
    KAFKA_ZOOKEEPER_USER="" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/kafka/bin:$PATH"

EXPOSE 9092

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
