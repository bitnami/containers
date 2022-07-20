FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-1-1" --checksum 6d176a8b3c894c608106fee2cf10aaf3771015defb0b7e08fe60ce6c9c1cd342
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "neo4j" "4.4.9-1" --checksum a876b065de82779318eda00d5a7b1bbb7534c9eccfcab4e2a3f63b91b3944534
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/neo4j/postunpack.sh
ENV APP_VERSION="4.4.9" \
    BITNAMI_APP_NAME="neo4j" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/neo4j/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 7473 7474 8756

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/neo4j/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/neo4j/run.sh" ]
