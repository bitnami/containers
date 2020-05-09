FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/solr/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr gnupg libc6 libgcc1 lsof procps sudo unzip
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install java-1.8.252-0 --checksum d7271eff41b312b73aea7aea3b79a6b1a69cf6613804803daff952aff7d440b4
RUN bitnami-pkg install tini-0.19.0-0 --checksum 9a8ae20be31a518f042fcec359f2cf35bfdb4e2a56f2fa8ff9ef2ecaf45da80c
RUN bitnami-pkg unpack solr-8.5.1-1 --checksum 70322ce81937ad5a094f8664a6ce0968a365ee1a9548c28a543754bb06ca5349
RUN bitnami-pkg install gosu-1.12.0-0 --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="8.5.1-debian-10-r20" \
    NAMI_PREFIX="/.nami" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="_default" \
    SOLR_HEAP="512m" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
