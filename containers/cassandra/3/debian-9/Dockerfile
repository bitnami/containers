FROM bitnami/minideb-extras:stretch-r90
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libblkid1 libbsd0 libbz2-1.0 libc6 libffi6 libgcc1 libglib2.0-0 libjemalloc1 libmount1 libncurses5 libpcre3 libreadline7 libselinux1 libsqlite3-0 libssl1.1 libstdc++6 libtinfo5 libuuid1 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 zlib1g
RUN bitnami-pkg install python-2.7.15-1 --checksum ffca53ea1dc9e9f582b1c5bab492df739461e58a9b7c3753180fb8bfcca7630d
RUN bitnami-pkg install java-1.8.181-0 --checksum fe9545bdf0a75f853a01046192f7076de685dc496a1d20427608c3c68b54029b
RUN bitnami-pkg unpack cassandra-3.11.2-5 --checksum 6c470245122f48d100c35b501cc12b624675a159c1f5cd301119ca216d07c480

COPY rootfs /
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.2-debian-9-r22" \
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
