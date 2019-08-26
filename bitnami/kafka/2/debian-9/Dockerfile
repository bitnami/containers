FROM bitnami/minideb-extras-base:stretch-r342
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "1.8.222-0" --checksum e5a677e160c01cd605bc6aae75cc937d4b2d37514b3e1d0a1dd2d332422e68c7
RUN . ./libcomponent.sh && component_unpack "kafka" "2.3.0-0" --checksum e2ce5f1f913c4e466e93742e87261a5f45c9b60b32853267464be5c643ab6a1a

COPY rootfs /
RUN /postunpack.sh
ENV ALLOW_PLAINTEXT_LISTENER="no" \
    BITNAMI_APP_NAME="kafka" \
    BITNAMI_IMAGE_VERSION="2.3.0-debian-9-r57" \
    KAFKA_BROKER_PASSWORD="bitnami" \
    KAFKA_BROKER_USER="user" \
    KAFKA_CERTIFICATE_PASSWORD="" \
    KAFKA_CFG_ADVERTISED_LISTENERS="PLAINTEXT://:9092" \
    KAFKA_CFG_LISTENERS="PLAINTEXT://:9092" \
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
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
