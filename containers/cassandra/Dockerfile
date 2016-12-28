FROM gcr.io/stacksmith-images/minideb:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=cassandra \
    BITNAMI_IMAGE_VERSION=3.9-r6 \
    PATH=/opt/bitnami/cassandra/bin:/opt/bitnami/java/bin:/opt/bitnami/python/bin:$PATH

# System packages required
RUN install_packages --no-install-recommends libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libsqlite3-0 libreadline6 libxext6 libx11-6 libxcb1 libxau6 libxdmcp6 libglib2.0-0 libfreetype6 libfontconfig1 libstdc++6 libgcc1 libselinux1 libpng12-0 libexpat1 libffi6 libpcre3 libxml2 liblzma5 libjemalloc1

# Additional modules required
RUN bitnami-pkg install python-2.7.12-3 --checksum 9a64785f30415bbd464ecfe3dabad9a6a3c2b897a0c32fd3ead7c227cffcc39c
RUN bitnami-pkg install java-1.8.0_111-1 --checksum f7705a3955f006eb59a6e4240a01d8273b17ba38428d30ffe7d10c9cc525d7be

# Install cassandra
RUN bitnami-pkg unpack cassandra-3.9-4 --checksum 47eb8a3b8b4b34d44af09fbd292369d3dbc6064249c3a55f3581eef714f58c58

COPY rootfs /

VOLUME ["/bitnami/cassandra"]

EXPOSE 7000 7001 9042 9160

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "cassandra"]
