FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.14-7" --checksum 900545c4f346a0ece8abf2caf64fd9d4ab7514967d4614d716bf7362b24f828b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "neo4j" "4.4.6-0" --checksum d75cf31f6e8d7c8e53c9ecf7cfa6de63d156de04d3e05122174cb4f22fe1862a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/neo4j/postunpack.sh
ENV APP_VERSION="4.4.6" \
    BITNAMI_APP_NAME="neo4j" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/neo4j/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 7473 7474 8756

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/neo4j/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/neo4j/run.sh" ]
