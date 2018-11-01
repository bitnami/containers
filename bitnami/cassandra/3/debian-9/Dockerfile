FROM bitnami/minideb-extras:stretch-r184
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libblkid1 libbsd0 libbz2-1.0 libc6 libffi6 libgcc1 libglib2.0-0 libjemalloc1 libmount1 libncurses5 libpcre3 libreadline7 libselinux1 libsqlite3-0 libssl1.1 libtinfo5 libuuid1 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 zlib1g
RUN bitnami-pkg install python-2.7.15-3 --checksum 3bad9208e166794f4716e1ccd7424581cb3c45362c4cd3f96165f2f3b5bb1a74
RUN bitnami-pkg install java-1.8.191-1 --checksum f05ed830d741b7dbdb3d09066552239023730516bdd2fd64578b66decd0ff867
RUN bitnami-pkg unpack cassandra-3.11.3-11 --checksum d55a610a00d2d7bbe53bb08e0d43b872274f70861e3bc8edda3e5953311ca7fb

COPY rootfs /
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.3-debian-9-r93" \
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
    CASSANDRA_STARTUP_CQL="" \
    CASSANDRA_TRANSPORT_PORT_NUMBER="7000" \
    CASSANDRA_USER="cassandra" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 9042 7000

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "cassandra" ]
