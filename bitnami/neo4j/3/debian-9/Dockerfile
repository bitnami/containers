FROM bitnami/minideb-extras:stretch-r265
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1
RUN bitnami-pkg install java-1.8.191-21 --checksum de7e78f5dbce5a3c2343e2a40f2f335868bd547598f1df364247b4425f2f2f1a
RUN bitnami-pkg unpack neo4j-3.5.2-0 --checksum 3a664b5d5fdc30ceca7f712e1ea6cfa12541ae85638eaece9c7eab681b2d1da1

COPY rootfs /
ENV BITNAMI_APP_NAME="neo4j" \
    BITNAMI_IMAGE_VERSION="3.5.2-debian-9-r4" \
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
