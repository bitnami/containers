FROM bitnami/minideb-extras:jessie-r24
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN bitnami-pkg install java-1.8.161-0 --checksum eb289afc43eda33d5920294460dc256f6543318506ca5a540bba9073412cfd06
RUN bitnami-pkg unpack neo4j-3.3.3-0 --checksum 0ef839567b99a7308aa0b58c6bcaccebf9416af4324dcfde10924ae68dfbc7ce

COPY rootfs /

ENV BITNAMI_APP_NAME="neo4j" \
    BITNAMI_IMAGE_VERSION="3.3.3-r1" \
    NEO4J_BOLT_PORT_NUMBER="7687" \
    NEO4J_HOST="" \
    NEO4J_HTTPS_PORT_NUMBER="7473" \
    NEO4J_HTTP_PORT_NUMBER="7474" \
    NEO4J_PASSWORD="bitnami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/neo4j/bin:$PATH"

EXPOSE 7474

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","neo4j"]
