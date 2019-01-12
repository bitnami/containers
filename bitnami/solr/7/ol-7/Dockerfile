FROM bitnami/oraclelinux-extras:7-r226
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc lsof
RUN bitnami-pkg install java-1.8.191-21 --checksum 2021c68dea11b0805161e15d5f1ee6e0670e148f262138fede55d41b488993fb
RUN bitnami-pkg unpack solr-7.6.0-0 --checksum 6a5010a6a30ed872ea4ef3b2e1852bb3bc560f1c7520b112c78fcfc3a85a4099

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="7.6.0-ol-7-r36" \
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
