FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="18.0.2-debian-11-r26" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/keycloak" \
      org.opencontainers.image.title="keycloak" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="18.0.2"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-154" --checksum 74a09c2208af7316f32ee3ee8479d70b20ad54f1a989e84b6417e23c1f07c147
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-1-3" --checksum 7214b8ab81c9d919f87f027590ca80c198f65fe50c5e2886d8e5e20691aee8d7
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "keycloak" "18.0.2-7" --checksum f0292899c9aeb4ebced7e4ba10b342177eca69d635dfcf5bbbb714459b6bcf68
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/keycloak/postunpack.sh
ENV APP_VERSION="18.0.2" \
    BITNAMI_APP_NAME="keycloak" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/java/bin:/opt/bitnami/keycloak/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/keycloak/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/keycloak/run.sh" ]
