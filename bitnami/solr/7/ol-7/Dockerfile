FROM bitnami/oraclelinux-extras:7-r141
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glib2 glibc libblkid libffi libgcc libmount libselinux libuuid lsof pcre zlib
RUN bitnami-pkg install java-1.8.191-0 --checksum b5815af4fe18301a0aebb58ae6fdb84444173c14f15252e8d8fe4015c454a43d
RUN bitnami-pkg unpack solr-7.5.0-1 --checksum 57d850d292b655c35b38d3602f1bc5ef6fe2ae0a91046f4e7f582c5ee0609857

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="7.5.0-ol-7-r26" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:$PATH" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="_default" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
