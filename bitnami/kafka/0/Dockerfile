FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libc6 libexpat1 libffi6 libfontconfig1 libfreetype6 libgcc1 libglib2.0-0 liblzma5 libpcre3 libpng12-0 libselinux1 libstdc++6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 zlib1g
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27
RUN bitnami-pkg unpack kafka-0.10.2-1-0 --checksum c7588059a280534fa70d8b8831ad282b3eb5ce68e32906de72e36f9934162c52

COPY rootfs /

ENV BITNAMI_APP_NAME="kafka" \
    BITNAMI_IMAGE_VERSION="0.10.2-1-r0" \
    KAFKA_ADVERTISED_HOST_NAME="" \
    KAFKA_ADVERTISED_LISTENERS="" \
    KAFKA_ADVERTISED_PORT="9092" \
    KAFKA_BROKER_ID="-1" \
    KAFKA_DELETE_TOPIC_ENABLE="false" \
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
    PATH="/opt/bitnami/java/bin:/opt/bitnami/kafka/bin:$PATH"



VOLUME ["/bitnami/kafka"]

EXPOSE 9092

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
