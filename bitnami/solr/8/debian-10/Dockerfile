FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr gnupg libc6 libgcc1 lsof procps sudo unzip zlib1g
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install java-1.8.242-0 --checksum 3a70f3d1c3cd9bc6ec581b2a10373a2b323c0b9af40402ce8d19aeb0b3d02400
RUN bitnami-pkg unpack solr-8.4.1-0 --checksum 3fc049c6a5c429bfdca2fcb0b2c74ea7a423fafd6f403d5e309573c006e77e32
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="8.4.1-debian-10-r8" \
    NAMI_PREFIX="/.nami" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="_default" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
