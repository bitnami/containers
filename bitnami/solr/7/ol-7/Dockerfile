FROM bitnami/oraclelinux-extras:7-r41
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glib2 glibc libblkid libffi libgcc libmount libselinux libstdc++ libuuid lsof pcre zlib
RUN bitnami-pkg install java-1.8.171-3 --checksum eb0af616b0a3ab12bd8559a36e83246eb10e7893f6a654dc14a462246d433e40
RUN bitnami-pkg unpack solr-7.4.0-1 --checksum 374080d2aad8e13e9967f29907cc451b233cfce38e359892ffe29fd08399b9fb

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="7.4.0-ol-7-r23" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:$PATH" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="_default" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
