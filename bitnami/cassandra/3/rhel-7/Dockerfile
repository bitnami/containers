FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libgcc libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre zlib
RUN bitnami-pkg install python-2.7.15-20 --checksum 026d98bfeddf908ba9774e2a54b992ece8877f5e07ed1e991f44747c2b22c59c
RUN bitnami-pkg install java-1.8.201-0 --checksum 9216aff7a05a39c45934859a19b66a5e1f343449fd929544a3aff1a6cddb35c2
RUN bitnami-pkg unpack cassandra-3.11.4-0 --checksum 2fb936b51dc046694afe15f6c444c5393a00726a0601148f3a35cf97ec1e273d
RUN mkdir -p /docker-entrypoint-initdb.d /opt/bitnami/cassandra/conf/
RUN chmod -R g+rwX /opt/bitnami/cassandra/conf/

COPY rootfs /
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.4-rhel-7-r0" \
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
