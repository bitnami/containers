FROM bitnami/oraclelinux-extras:7-r94
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glib2 glibc libblkid libffi libgcc libmount libselinux libstdc++ libuuid lsof pcre zlib
RUN bitnami-pkg install java-1.8.181-1 --checksum 6e7fc2779b6e0e3c6c0a2687b1d747d8a427594ff80b8c94b055c839e387e6b1
RUN bitnami-pkg unpack solr-7.4.0-2 --checksum b9f3e37b498c004d9b3bea8dcbabb3d181955ad7765785b7b21602ff8c6ce47d

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="7.4.0-ol-7-r58" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:$PATH" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="_default" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
