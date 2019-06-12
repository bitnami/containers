FROM bitnami/oraclelinux-extras:7-r365
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc
RUN bitnami-pkg install java-1.8.212-0 --checksum 7d11dad71234819fb290bcadc2997bda088ba6b21f245d397c068de4cf3757db
RUN bitnami-pkg unpack kafka-1.1.1-30 --checksum 31c3f9d7712eaceb152a53d483764eb5b5c2d75724744f7ba4bf0398b88df3de

COPY rootfs /
ENV ALLOW_PLAINTEXT_LISTENER="no" \
    BITNAMI_APP_NAME="kafka" \
    BITNAMI_IMAGE_VERSION="1.1.1-ol-7-r305" \
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
