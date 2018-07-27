FROM bitnami/oraclelinux-extras:7-r49
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs glib2 glibc keyutils-libs krb5-libs libblkid libcom_err libffi libgcc libmount libselinux libstdc++ libuuid ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install python-2.7.15-1 --checksum b68b70cfe101ab13fc94c774c62915ed44207261b6a5ee091f0b504a1d73e945
RUN bitnami-pkg install java-1.8.181-0 --checksum 3ec0988309e2ecdda95d6a28b0280e499a33ed1f3107d8e8a22ce702d51ab306
RUN bitnami-pkg unpack cassandra-3.11.2-5 --checksum 6347827396ddce308f91ced1f7df9c338ed9795c39569e14af12b65969f3047b

COPY rootfs /
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.2-ol-7-r33" \
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
