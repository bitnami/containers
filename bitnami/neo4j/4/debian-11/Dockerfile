FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-0" --checksum fe6b65886a6b1f545508e272efbf422054ee030c867f94ebec2f93c5518252de
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "neo4j" "4.4.7-1" --checksum 1672727dea641b0520da328682c271000f35b6c26627ac6dc1040b279a63ed50
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/neo4j/postunpack.sh
ENV APP_VERSION="4.4.7" \
    BITNAMI_APP_NAME="neo4j" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/neo4j/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 7473 7474 8756

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/neo4j/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/neo4j/run.sh" ]
