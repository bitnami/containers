FROM bitnami/oraclelinux-extras:7-r392
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc lsof
RUN bitnami-pkg install java-1.8.212-0 --checksum 7d11dad71234819fb290bcadc2997bda088ba6b21f245d397c068de4cf3757db
RUN bitnami-pkg unpack solr-8.1.1-0 --checksum 03f2e29edd44e279b081970c5d01c9e1e4c3332910ce8ac379d5682aa7c4077b

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="8.1.1-ol-7-r43" \
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
