FROM bitnami/minideb-extras:jessie-r95
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN bitnami-pkg install java-1.8.171-3 --checksum 3454a0bda3a4fb282b6b9a7022677a48dc493df0e13cb04d3c92e070e102a244
RUN bitnami-pkg unpack neo4j-3.4.1-0 --checksum f38135a2e4b4a9dfa27e52ef8158cd1ca9d7cf326097c6f91762551253b8fafc

COPY rootfs /
ENV BITNAMI_APP_NAME="neo4j" \
    BITNAMI_IMAGE_VERSION="3.4.1-r19" \
    NEO4J_BOLT_PORT_NUMBER="7687" \
    NEO4J_HOST="" \
    NEO4J_HTTPS_PORT_NUMBER="7473" \
    NEO4J_HTTP_PORT_NUMBER="7474" \
    NEO4J_PASSWORD="bitnami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/neo4j/bin:$PATH"

EXPOSE 7474 7473 8756

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","neo4j"]
