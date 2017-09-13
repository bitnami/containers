FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libffi6 libgcc1 libglib2.0-0 liblzma5 libpcre3 libselinux1 libstdc++6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 zlib1g
RUN bitnami-pkg install java-1.8.144-0 --checksum 8b4315727f65780d8223df0aeaf5e3beca10a14aa4e2cdd1f3541ab50b346433
RUN bitnami-pkg unpack kafka-0.11.0-1-0 --checksum 40cc89ffd7e50590cbc3903b549622948b3a709d0193ca9e6c2d1005136faa1e

COPY rootfs /

ENV ALLOW_PLAINTEXT_LISTENER="no" \
    BITNAMI_APP_NAME="kafka" \
    BITNAMI_IMAGE_VERSION="0.11.0-1-r0" \
    KAFKA_ADVERTISED_HOST_NAME="" \
    KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://:9092" \
    KAFKA_ADVERTISED_PORT="9092" \
    KAFKA_BROKER_ID="-1" \
    KAFKA_BROKER_PASSWORD="bitnami" \
    KAFKA_BROKER_USER="user" \
    KAFKA_DELETE_TOPIC_ENABLE="false" \
    KAFKA_HEAP_OPTS="-Xmx1024m -Xms1024m" \
    KAFKA_INTER_BROKER_PASSWORD="bitnami" \
    KAFKA_INTER_BROKER_USER="admin" \
    KAFKA_LISTENERS="PLAINTEXT://:9092" \
    KAFKA_LOGS_DIRS="/opt/bitnami/kafka/logs" \
    KAFKA_LOG_FLUSH_INTERVAL_MESSAGES="10000" \
    KAFKA_LOG_FLUSH_INTERVAL_MS="1000" \
    KAFKA_LOG_RETENTION_BYTES="1073741824" \
    KAFKA_LOG_RETENTION_CHECK_INTERVALS_MS="300000" \
    KAFKA_LOG_RETENTION_HOURS="168" \
    KAFKA_NUM_IO_THREADS="8" \
    KAFKA_NUM_NETWORK_THREADS="3" \
    KAFKA_NUM_PARTITIONS="1" \
    KAFKA_NUM_RECOVERY_THREADS_PER_DATA_DIR="1" \
    KAFKA_PORT_NUMBER="9092" \
    KAFKA_SEGMENT_BYTES="1073741824" \
    KAFKA_SOCKET_RECEIVE_BUFFER_BYTES="102400" \
    KAFKA_SOCKET_REQUEST_MAX_BYTES="104857600" \
    KAFKA_SOCKET_SEND_BUFFER_BYTES="102400" \
    KAFKA_ZOOKEEPER_CONNECT="localhost:2181" \
    KAFKA_ZOOKEEPER_CONNECT_TIMEOUT_MS="6000" \
    KAFKA_ZOOKEEPER_PASSWORD="" \
    KAFKA_ZOOKEEPER_USER="" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/kafka/bin:$PATH"

EXPOSE 9092

USER 1001
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
