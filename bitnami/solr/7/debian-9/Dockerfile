FROM bitnami/minideb-extras:stretch-r71
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libblkid1 libbsd0 libc6 libffi6 libgcc1 libglib2.0-0 libmount1 libpcre3 libselinux1 libstdc++6 libuuid1 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 lsof zlib1g
RUN bitnami-pkg install java-1.8.171-3 --checksum 100e1e457e19648410be57716eb075f43936aeaa2ac51457d2b46abc2b810ddc
RUN bitnami-pkg unpack solr-7.4.0-1 --checksum 7c1cf438357668f7647007e2d7e6e602c489acb1598399cbcbb2ac88f84ac976

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="7.4.0-debian-9-r1" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:$PATH" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="_default" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
