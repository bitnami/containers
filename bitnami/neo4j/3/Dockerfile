FROM bitnami/minideb-extras:jessie-r60
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN bitnami-pkg install java-1.8.171-2 --checksum 43dee4edccde5428da7b62dbd8371a08cd4f92ebfa3dca104f1e3d8480610cda
RUN bitnami-pkg unpack neo4j-3.3.5-0 --checksum 53bc23062e1dfe2a72220c9291122d3f11255016a9ae77040b341cebb13253d4

COPY rootfs /
ENV BITNAMI_APP_NAME="neo4j" \
    BITNAMI_IMAGE_VERSION="3.3.5-r28" \
    NEO4J_BOLT_PORT_NUMBER="7687" \
    NEO4J_HOST="" \
    NEO4J_HTTPS_PORT_NUMBER="7473" \
    NEO4J_HTTP_PORT_NUMBER="7474" \
    NEO4J_PASSWORD="bitnami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/neo4j/bin:$PATH"

EXPOSE 7474 7473 8756

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","neo4j"]
