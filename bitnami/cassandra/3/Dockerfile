FROM bitnami/minideb-extras:jessie-r24
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libjemalloc1 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libtinfo5 zlib1g
RUN bitnami-pkg install python-2.7.14-1 --checksum 8ffb7eaa43bc85a31b8bb9d844332c0f7e3e64e0578cd3ecddabc87ab3695c1e
RUN bitnami-pkg install java-1.8.161-0 --checksum eb289afc43eda33d5920294460dc256f6543318506ca5a540bba9073412cfd06
RUN bitnami-pkg unpack cassandra-3.11.2-2 --checksum 39b08d2924c7240cde06720b3acc70d746d3e1e1a6edc4758629d303dcc6896c

COPY rootfs /

ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.2-r5" \
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
