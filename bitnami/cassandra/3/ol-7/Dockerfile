FROM bitnami/oraclelinux-extras:7-r152
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs glib2 glibc keyutils-libs krb5-libs libblkid libcom_err libffi libgcc libmount libselinux libuuid ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install python-2.7.15-3 --checksum 4830fe03caf91b28ad6612fdaf4114c1a5e3dc00faa081dab44bf9567699797b
RUN bitnami-pkg install java-1.8.191-1 --checksum 3997bf3325da463f2392c36882a1d56e52b5a52ce7124b7895755b4e95454032
RUN bitnami-pkg unpack cassandra-3.11.3-11 --checksum f9bfa15f3bbb94e1b77460560d80e3609a85f7228b159d8a98d4ab3aca45bfc7

COPY rootfs /
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.3-ol-7-r76" \
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
