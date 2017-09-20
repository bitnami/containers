FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN bitnami-pkg install java-1.8.144-1 --checksum 2f8fdda7d9a8d8ad57efc76fe2b1a322a9ec30395b6bcb09464901256348066c
RUN bitnami-pkg unpack solr-7.0.0-0 --checksum a75cf9682b63d97fdacb3f75d4a4c3710abb56d0aaeff4c4469e99b91ba08b27

COPY rootfs /

ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="7.0.0-r0" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:$PATH" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="data_driven_schema_configs" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","solr"]
