FROM bitnami/oraclelinux-extras:7-r339
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc
RUN bitnami-pkg install java-1.8.212-0 --checksum 7d11dad71234819fb290bcadc2997bda088ba6b21f245d397c068de4cf3757db
RUN bitnami-pkg unpack neo4j-3.5.5-0 --checksum 9a48e01239b4498a7072deaa2a8785986cf3b2f4bc6a3b40271373406996fc40

COPY rootfs /
ENV BITNAMI_APP_NAME="neo4j" \
    BITNAMI_IMAGE_VERSION="3.5.5-ol-7-r9" \
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
