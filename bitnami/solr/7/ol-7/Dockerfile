FROM bitnami/oraclelinux-extras:7-r48
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glib2 glibc libblkid libffi libgcc libmount libselinux libstdc++ libuuid lsof pcre zlib
RUN bitnami-pkg install java-1.8.181-0 --checksum 3ec0988309e2ecdda95d6a28b0280e499a33ed1f3107d8e8a22ce702d51ab306
RUN bitnami-pkg unpack solr-7.4.0-1 --checksum 374080d2aad8e13e9967f29907cc451b233cfce38e359892ffe29fd08399b9fb

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="7.4.0-ol-7-r28" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:$PATH" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="_default" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
