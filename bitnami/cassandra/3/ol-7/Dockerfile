FROM bitnami/oraclelinux-extras:7-r259
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs glibc keyutils-libs krb5-libs libcom_err libgcc libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install python-2.7.15-20 --checksum 74fe4964d24180d043f2ee328097a414c69ac7c955cfad228057bbeb9b4ab96f
RUN bitnami-pkg install java-1.8.201-0 --checksum e71b797ceaaf8b0641d1641df129cea10124b058bc24d4ed74738725fabfb8c9
RUN bitnami-pkg unpack cassandra-3.11.4-0 --checksum 4b75302b4ad0db7ef5bf10ba94df046b8d6d0d633afe505927fa1bd62f4ab271
RUN mkdir -p /docker-entrypoint-initdb.d /opt/bitnami/cassandra/conf/
RUN chmod -R g+rwX /opt/bitnami/cassandra/conf/

COPY rootfs /
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.4-ol-7-r1" \
    CASSANDRA_CLIENT_ENCRYPTION="false" \
    CASSANDRA_CLUSTER_NAME="My Cluster" \
    CASSANDRA_CQL_PORT_NUMBER="9042" \
    CASSANDRA_DATACENTER="dc1" \
    CASSANDRA_ENABLE_REMOTE_CONNECTIONS="true" \
    CASSANDRA_ENABLE_RPC="true" \
    CASSANDRA_ENDPOINT_SNITCH="SimpleSnitch" \
    CASSANDRA_HOST="" \
    CASSANDRA_INTERNODE_ENCRYPTION="none" \
    CASSANDRA_JMX_PORT_NUMBER="7199" \
    CASSANDRA_KEYSTORE_PASSWORD="cassandra" \
    CASSANDRA_NUM_TOKENS="256" \
    CASSANDRA_PASSWORD="cassandra" \
    CASSANDRA_PASSWORD_SEEDER="no" \
    CASSANDRA_RACK="rack1" \
    CASSANDRA_SEEDS="" \
    CASSANDRA_STARTUP_CQL="" \
    CASSANDRA_TRANSPORT_PORT_NUMBER="7000" \
    CASSANDRA_TRUSTSTORE_PASSWORD="cassandra" \
    CASSANDRA_USER="cassandra" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 9042 7000

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
