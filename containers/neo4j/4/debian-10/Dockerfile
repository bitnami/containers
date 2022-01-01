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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.13-0" --checksum 9552e53ccd3b0ec85a82c31c26a1462260e28b7c58770a5c53560afb02ec66d9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "neo4j" "4.4.2-0" --checksum d84ae8ce5659c58a170d543b45c74e7afd8d58b22fe080c0aaf611c240e3dba6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/neo4j/postunpack.sh
ENV BITNAMI_APP_NAME="neo4j" \
    BITNAMI_IMAGE_VERSION="4.4.2-debian-10-r14" \
    JAVA_HOME="/opt/bitnami/java" \
    NEO4J_BOLT_PORT_NUMBER="" \
    NEO4J_HOST="" \
    NEO4J_HTTPS_PORT_NUMBER="" \
    NEO4J_HTTP_PORT_NUMBER="" \
    NEO4J_PASSWORD="" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/neo4j/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 7473 7474 8756

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/neo4j/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/neo4j/run.sh" ]
