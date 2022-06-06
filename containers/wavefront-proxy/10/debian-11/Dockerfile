FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-0" --checksum fe6b65886a6b1f545508e272efbf422054ee030c867f94ebec2f93c5518252de
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wavefront-proxy" "10.14.0-0" --checksum 840a943b6c0e8d7509e8079659884053da2279826b2930f8574492d5b1642c9e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/wavefront-proxy/postunpack.sh
ENV APP_VERSION="10.14.0" \
    BITNAMI_APP_NAME="wavefront-proxy" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 2878

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/wavefront-proxy/entrypoint.sh" ]
CMD [ "/opt/bitnami/wavefront-proxy/scripts/run.sh" ]
