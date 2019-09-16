FROM bitnami/minideb-extras:stretch-r479
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 zlib1g
RUN bitnami-pkg install java-1.8.222-0 --checksum e5a677e160c01cd605bc6aae75cc937d4b2d37514b3e1d0a1dd2d332422e68c7
RUN bitnami-pkg unpack neo4j-3.5.9-0 --checksum bc04929d4b856424c10a4e7b6150902fa73d921483b1c000089676387abbff20

COPY rootfs /
ENV BITNAMI_APP_NAME="neo4j" \
    BITNAMI_IMAGE_VERSION="3.5.9-debian-9-r14" \
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
