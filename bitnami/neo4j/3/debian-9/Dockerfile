FROM bitnami/minideb-extras:stretch-r484
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 zlib1g
RUN bitnami-pkg install java-1.8.222-1 --checksum 373c9f3d2943b9ff653fc0e7c69b1d54a75807726691a09190648808500b8253
RUN bitnami-pkg unpack neo4j-3.5.9-1 --checksum d696ee7dafe4c71feb982d4c74ab238ec6f652e50f1f5283c18e3dab51204f1b

COPY rootfs /
ENV BITNAMI_APP_NAME="neo4j" \
    BITNAMI_IMAGE_VERSION="3.5.9-debian-9-r21" \
    NAMI_PREFIX="/.nami" \
    NEO4J_BOLT_PORT_NUMBER="7687" \
    NEO4J_HOST="" \
    NEO4J_HTTPS_PORT_NUMBER="7473" \
    NEO4J_HTTP_PORT_NUMBER="7474" \
    NEO4J_PASSWORD="bitnami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/neo4j/bin:$PATH"

EXPOSE 7474 7473 8756

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "neo4j" ]
