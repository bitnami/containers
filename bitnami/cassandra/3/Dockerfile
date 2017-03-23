FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=cassandra \
    BITNAMI_IMAGE_VERSION=3.10-r3 \
    PATH=/opt/bitnami/cassandra/bin:/opt/bitnami/java/bin:/opt/bitnami/python/bin:$PATH

# System packages required
RUN install_packages libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libsqlite3-0 libreadline6 libxext6 libx11-6 libxcb1 libxau6 libxdmcp6 libglib2.0-0 libfreetype6 libfontconfig1 libstdc++6 libgcc1 libselinux1 libpng12-0 libexpat1 libffi6 libpcre3 libxml2 liblzma5 libjemalloc1

# Additional modules required
RUN bitnami-pkg install python-2.7.13-0 --checksum 7f5aac196054c7eb04c981243b4ddf37020cc3eb8a7cdc69d72da57212b21573
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27

# Install cassandra
RUN bitnami-pkg unpack cassandra-3.10-0 --checksum 548dd6e6ccdc22e6c479a0f914b50d44fce948383536a1e6d6abe3dd82a39fa0

COPY rootfs /

ENV CASSANDRA_CLUSTER_NAME="My Cluster" \
    CASSANDRA_TRANSPORT_PORT="7000" \
    CASSANDRA_SSL_TRANSPORT_PORT="7001" \
    CASSANDRA_JMX_PORT="7199" \
    CASSANDRA_CQL_PORT="9042" \
    CASSANDRA_RPC_PORT="9160" \
    CASSANDRA_USER="cassandra" \
    CASSANDRA_PASSWORD="cassandra" \
    CASSANDRA_ENDPOINT_SNITCH="SimpleSnitch"

VOLUME ["/bitnami/cassandra"]

EXPOSE 7000 7001 9042 9160

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "cassandra"]
