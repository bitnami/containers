FROM bitnami/oraclelinux-extras:7-r43
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glib2 glibc libblkid libffi libgcc libmount libselinux libstdc++ libuuid pcre zlib
RUN bitnami-pkg install java-1.8.171-3 --checksum eb0af616b0a3ab12bd8559a36e83246eb10e7893f6a654dc14a462246d433e40
RUN bitnami-pkg unpack neo4j-3.4.4-0 --checksum 53737e4dc76c29a2a153f8b1588a195894b0fb1fdb1716f763d096a92119a242

COPY rootfs /
ENV BITNAMI_APP_NAME="neo4j" \
    BITNAMI_IMAGE_VERSION="3.4.4-ol-7-r2" \
    NEO4J_BOLT_PORT_NUMBER="7687" \
    NEO4J_HOST="" \
    NEO4J_HTTPS_PORT_NUMBER="7473" \
    NEO4J_HTTP_PORT_NUMBER="7474" \
    NEO4J_PASSWORD="bitnami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/neo4j/bin:$PATH"

EXPOSE 7474 7473 8756

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","neo4j"]
