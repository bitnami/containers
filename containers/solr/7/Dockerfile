FROM bitnami/minideb-extras:jessie-r69
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages lsof
RUN bitnami-pkg install java-1.8.171-3 --checksum 3454a0bda3a4fb282b6b9a7022677a48dc493df0e13cb04d3c92e070e102a244
RUN bitnami-pkg unpack solr-7.3.1-0 --checksum 20618d803b7a535d2ae33936ae80e7b1c3dbb288669b833ae29f6f822ccaab0a

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="7.3.1-r14" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:$PATH" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="data_driven_schema_configs" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
