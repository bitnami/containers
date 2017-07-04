FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libc6 libexpat1 libffi6 libfontconfig1 libfreetype6 libgcc1 libglib2.0-0 libjemalloc1 liblzma5 libncurses5 libpcre3 libpng12-0 libreadline6 libselinux1 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 zlib1g
RUN bitnami-pkg install python-2.7.13-0 --checksum 7f5aac196054c7eb04c981243b4ddf37020cc3eb8a7cdc69d72da57212b21573
RUN bitnami-pkg install java-1.8.131-0 --checksum 5b122a36c8ba44e2f9eb8cbb9b62dd87963742c46f85a04019115d2d43c69e33
RUN bitnami-pkg unpack cassandra-3.11.0-0 --checksum 44951b1da39f42584dc3a5ec94cded35fcec5e008e3b5d3fc64067f0bf9ef6da

COPY rootfs /

ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.0-r2" \
    CASSANDRA_CLUSTER_NAME="My Cluster" \
    CASSANDRA_CQL_PORT_NUMBER="9042" \
    CASSANDRA_ENABLE_REMOTE_CONNECTIONS="true" \
    CASSANDRA_ENDPOINT_SNITCH="SimpleSnitch" \
    CASSANDRA_HOST="" \
    CASSANDRA_JMX_PORT_NUMBER="7199" \
    CASSANDRA_NUM_TOKENS="256" \
    CASSANDRA_PASSWORD="cassandra" \
    CASSANDRA_RPC_PORT_NUMBER="9160" \
    CASSANDRA_SEEDS="" \
    CASSANDRA_SET_CREDENTIALS="1" \
    CASSANDRA_SSL_TRANSPORT_PORT_NUMBER="7001" \
    CASSANDRA_TRANSPORT_PORT_NUMBER="7000" \
    CASSANDRA_USER="cassandra" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/cassandra/bin:$PATH"




EXPOSE 9042 9160 7000 7001

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","cassandra"]
