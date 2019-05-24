FROM bitnami/minideb-extras:stretch-r369
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 lsof
RUN bitnami-pkg install java-1.8.212-0 --checksum 54a18672c8b4c1a44324c607a6bc616f614a062005d5e3384f91f10ff6f6edea
RUN bitnami-pkg unpack solr-8.1.0-0 --checksum 27d2e2163940f0199b6e7b30ddf8656cdddbb2c3a6f9634fa8f2762446500866

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="8.1.0-debian-9-r11" \
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
