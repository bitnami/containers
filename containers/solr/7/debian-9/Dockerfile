FROM bitnami/minideb-extras:stretch-r180
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libblkid1 libbsd0 libc6 libffi6 libgcc1 libglib2.0-0 libmount1 libpcre3 libselinux1 libuuid1 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 lsof zlib1g
RUN bitnami-pkg install java-1.8.191-1 --checksum f05ed830d741b7dbdb3d09066552239023730516bdd2fd64578b66decd0ff867
RUN bitnami-pkg unpack solr-7.5.0-2 --checksum be139ac713a24c8d278a4bd888d71d907adb73196e4b7701e4df151d80e0493f

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="7.5.0-debian-9-r28" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:$PATH" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="_default" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
