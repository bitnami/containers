FROM bitnami/oraclelinux-extras:7-r586
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages glibc libgcc lsof zlib
RUN bitnami-pkg install java-1.8.232-0 --checksum fbac74363c807fce14538c5f9a9232602adc7883c1c5936571c741625de2479e
RUN bitnami-pkg unpack solr-8.4.0-0 --checksum a5905eddcb620c6f81ce4a25c19b5ba44edbf4203c352772c095b37f2103f319

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="8.4.0-ol-7-r6" \
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
