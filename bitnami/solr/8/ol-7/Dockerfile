FROM bitnami/oraclelinux-extras:7-r475
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc lsof zlib
RUN bitnami-pkg install java-1.8.222-1 --checksum 664cacaa11342e877410b197d21343543c2987cd66f15d2adc32cc61eee48eaa
RUN bitnami-pkg unpack solr-8.2.0-1 --checksum a65642999db4864ccc773db6532b75ef34c0aaf0d3b0ecd1da4265d49a3ccf87

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="8.2.0-ol-7-r60" \
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
