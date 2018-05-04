FROM bitnami/minideb-extras:jessie-r38
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libjemalloc1 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libtinfo5 zlib1g
RUN bitnami-pkg install python-2.7.15-0 --checksum cf348044cb4f3125332456c19d8c5f43807da7f20ad7115260f96cded3e0ad4c
RUN bitnami-pkg install java-1.8.171-0 --checksum c5ea6aa978992a3606b070b3ef4287b0b8118611f015281868f4466a81c299b1
RUN bitnami-pkg unpack cassandra-3.11.2-3 --checksum 6579d295e0ca66f082582e419c91e2d7702e00b6f3a6ebe14a994786b5aa764a

COPY rootfs /
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.2-r17" \
    CASSANDRA_CLUSTER_NAME="My Cluster" \
    CASSANDRA_CQL_PORT_NUMBER="9042" \
    CASSANDRA_ENABLE_REMOTE_CONNECTIONS="true" \
    CASSANDRA_ENDPOINT_SNITCH="SimpleSnitch" \
    CASSANDRA_HOST="" \
    CASSANDRA_JMX_PORT_NUMBER="7199" \
    CASSANDRA_NUM_TOKENS="256" \
    CASSANDRA_PASSWORD="cassandra" \
    CASSANDRA_PASSWORD_SEEDER="no" \
    CASSANDRA_SEEDS="" \
    CASSANDRA_TRANSPORT_PORT_NUMBER="7000" \
    CASSANDRA_USER="cassandra" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 9042 7000

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","cassandra"]
