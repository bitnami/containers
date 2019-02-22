FROM bitnami/minideb-extras:stretch-r291
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 lsof
RUN bitnami-pkg install java-1.8.201-0 --checksum de49557872836fdbd965389ebcc72e163f7242cf691d435993cc2e4f3cd56ae7
RUN bitnami-pkg unpack solr-7.7.0-0 --checksum 99c27a88a8cc731b093add1d786cc27bd20b41862f6e9e0ddebb7b2bc8347a84

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="7.7.0-debian-9-r4" \
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
