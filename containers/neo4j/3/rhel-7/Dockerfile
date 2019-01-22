FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc
RUN bitnami-pkg install java-1.8.191-0 --checksum 8593f8fb14f68c8b801b2f791bb977c8d60004938f791ce43a37978227f37920
RUN bitnami-pkg unpack neo4j-3.5.2-0 --checksum 69911f146bc68fe275fb19de1ad89ff43fa6a3a5d779f9bf9ddf1cc15b9777a1

COPY rootfs /
ENV BITNAMI_APP_NAME="neo4j" \
    BITNAMI_IMAGE_VERSION="3.5.2-rhel-7-r0" \
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
