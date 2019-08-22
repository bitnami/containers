FROM bitnami/oraclelinux-extras:7-r436
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc zlib
RUN bitnami-pkg install java-1.8.222-0 --checksum a90f4ce71ff9b392efdf61e6941117afa31d2d6528bd1a3cad1c6459bcac2b0b
RUN bitnami-pkg unpack neo4j-3.5.8-0 --checksum 72da23434cc25a26cc4963d419bfa98e07ed557b59dfe25e8e7ed497ca516f24

COPY rootfs /
ENV BITNAMI_APP_NAME="neo4j" \
    BITNAMI_IMAGE_VERSION="3.5.8-ol-7-r32" \
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
