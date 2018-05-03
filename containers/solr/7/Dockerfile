FROM bitnami/minideb-extras:jessie-r37
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages lsof
RUN bitnami-pkg install java-1.8.171-0 --checksum c5ea6aa978992a3606b070b3ef4287b0b8118611f015281868f4466a81c299b1
RUN bitnami-pkg unpack solr-7.3.0-0 --checksum 7a9df4abc618d9bcc71697b48b80290415f89f53bf166b86385197985bd92635

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="7.3.0-r10" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:$PATH" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="data_driven_schema_configs" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
