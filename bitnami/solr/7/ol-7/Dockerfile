FROM bitnami/oraclelinux-extras:7-r196
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glib2 glibc libblkid libffi libgcc libmount libselinux libuuid lsof pcre zlib
RUN bitnami-pkg install java-1.8.191-20 --checksum 385a62502dbd62180858f6d4f6afde334dad9862e0caab022c2327b467d1283d
RUN bitnami-pkg unpack solr-7.5.0-20 --checksum 05eb883195e30c9d2e091679a4ec56240d0ffb59afa9d9678ad89a71631cbeae

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="7.5.0-ol-7-r78" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:$PATH" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="_default" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
