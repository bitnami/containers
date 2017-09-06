FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libffi6 libgcc1 libglib2.0-0 liblzma5 libpcre3 libselinux1 libstdc++6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 zlib1g
RUN bitnami-pkg install java-1.8.144-0 --checksum 8b4315727f65780d8223df0aeaf5e3beca10a14aa4e2cdd1f3541ab50b346433
RUN bitnami-pkg unpack solr-6.6.1-0 --checksum 0599481ecdc8fd2d2628646b745f5c911996a3f024a4f879afacecff2ed17084

COPY rootfs /

ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="6.6.1-r0" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:$PATH" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="data_driven_schema_configs" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","solr"]
