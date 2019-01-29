FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc lsof
RUN bitnami-pkg install java-1.8.191-0 --checksum 8593f8fb14f68c8b801b2f791bb977c8d60004938f791ce43a37978227f37920
RUN bitnami-pkg unpack solr-7.6.0-0 --checksum b233c2062ea5e0d1ee829c3613ea8b207fdfa238699706f1cf2f8ff8c9a43ae0

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="7.6.0-rhel-7-r0" \
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
