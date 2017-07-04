FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libc6 libffi6 libgcc1 libglib2.0-0 liblzma5 libpcre3 libselinux1 libstdc++6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 zlib1g
RUN bitnami-pkg install java-1.8.131-0 --checksum 5b122a36c8ba44e2f9eb8cbb9b62dd87963742c46f85a04019115d2d43c69e33
RUN bitnami-pkg unpack solr-6.6.0-0 --checksum 59ee7cb1e432218b927211fab63fd22a945771f1c16de1f948c7a77ebd86d1cc

COPY rootfs /

ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="6.6.0-r0" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:$PATH" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="data_driven_schema_configs" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"




EXPOSE 8983

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","solr"]
